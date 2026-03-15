import argparse
import asyncio
import json
import time

import boto3
import httpx


def get_id_token(
    username: str,
    password: str,
    client_id: str,
    user_pool_id: str | None = None,
) -> str:
    cognito = boto3.client("cognito-idp", region_name="us-east-1")
    response = cognito.initiate_auth(
        ClientId=client_id,
        AuthFlow="USER_PASSWORD_AUTH",
        AuthParameters={
            "USERNAME": username,
            "PASSWORD": password,
        },
    )
    if "AuthenticationResult" in response:
        return response["AuthenticationResult"]["IdToken"]

    challenge_name = response.get("ChallengeName")
    if challenge_name == "NEW_PASSWORD_REQUIRED":
        if not user_pool_id:
            raise RuntimeError(
                "Cognito returned NEW_PASSWORD_REQUIRED. Re-run with --user-pool-id "
                "to auto-set a permanent password and continue."
            )

        cognito.admin_set_user_password(
            UserPoolId=user_pool_id,
            Username=username,
            Password=password,
            Permanent=True,
        )

        retry = cognito.initiate_auth(
            ClientId=client_id,
            AuthFlow="USER_PASSWORD_AUTH",
            AuthParameters={
                "USERNAME": username,
                "PASSWORD": password,
            },
        )
        if "AuthenticationResult" not in retry:
            raise RuntimeError(f"Unexpected Cognito auth response: {retry}")
        return retry["AuthenticationResult"]["IdToken"]

    raise RuntimeError(f"Unexpected Cognito auth response: {response}")


async def call_endpoint(
    client: httpx.AsyncClient,
    method: str,
    url: str,
    expected_region: str,
    token: str,
):
    started = time.perf_counter()
    response = await client.request(
        method,
        url,
        headers={"Authorization": token},
    )
    latency_ms = (time.perf_counter() - started) * 1000

    response.raise_for_status()
    payload = response.json()
    body = payload
    if "body" in payload and isinstance(payload["body"], str):
        body = json.loads(payload["body"])

    observed_region = body.get("region")
    assert (
        observed_region == expected_region
    ), f"{url} returned region {observed_region}, expected {expected_region}"

    print(f"{method} {url}")
    print(json.dumps(body, indent=2))
    print(f"Latency: {latency_ms:.2f} ms\n")

    return {
        "url": url,
        "method": method,
        "expected_region": expected_region,
        "observed_region": observed_region,
        "latency_ms": latency_ms,
    }


async def main():
    parser = argparse.ArgumentParser(
        description="Authenticate with Cognito and test both regional APIs concurrently."
    )
    parser.add_argument("--user-pool-client-id", required=True)
    parser.add_argument("--user-pool-id", required=False)
    parser.add_argument("--username", required=True)
    parser.add_argument("--password", required=True)
    parser.add_argument("--api-us-east-1", required=True)
    parser.add_argument("--api-eu-west-1", required=True)
    args = parser.parse_args()

    token = get_id_token(
        args.username,
        args.password,
        args.user_pool_client_id,
        args.user_pool_id,
    )

    async with httpx.AsyncClient(timeout=30.0) as client:
        greet_results = await asyncio.gather(
            call_endpoint(
                client,
                "GET",
                f"{args.api_us_east_1.rstrip('/')}/greet",
                "us-east-1",
                token,
            ),
            call_endpoint(
                client,
                "GET",
                f"{args.api_eu_west_1.rstrip('/')}/greet",
                "eu-west-1",
                token,
            ),
        )

        dispatch_results = await asyncio.gather(
            call_endpoint(
                client,
                "POST",
                f"{args.api_us_east_1.rstrip('/')}/dispatch",
                "us-east-1",
                token,
            ),
            call_endpoint(
                client,
                "POST",
                f"{args.api_eu_west_1.rstrip('/')}/dispatch",
                "eu-west-1",
                token,
            ),
        )

    print("Greet latency comparison (ms):")
    for result in greet_results:
        print(f"{result['expected_region']}: {result['latency_ms']:.2f}")

    print("\nDispatch latency comparison (ms):")
    for result in dispatch_results:
        print(f"{result['expected_region']}: {result['latency_ms']:.2f}")


if __name__ == "__main__":
    asyncio.run(main())
