#!/usr/bin/env python3

from argparse import ArgumentParser
from typing import Dict
import requests
import json

parser = ArgumentParser(
    description="Simple crypto currency module to display crypto currencies prices on a line"
)

parser.add_argument(
    "--coingecko-base-url",
    type=str,
    nargs="?",
    default="https://api.coingecko.com/api/v3/",
    help="Coingecko's API base url",
)
parser.add_argument(
    "-b", "--base", type=str, nargs="?", default="usd", help="Base currency"
)
parser.add_argument(
    "-c",
    "--configuration-file-path",
    type=str,
    nargs="?",
    default="./simple_crypto.json",
    help="Configuration file path",
)


def load_configuration(file_path: str) -> Dict[str, str]:
    with open(file_path, "r") as f:
        return json.load(f)


if __name__ == "__main__":
    args = parser.parse_args()
    conf = load_configuration(args.configuration_file_path)
    res = requests.get(
        f"{args.coingecko_base_url}/simple/price?precision=2&vs_currencies={args.base}&ids={','.join(conf.keys())}"
    )

    if res.status_code == 200:
        print(" ".join([f"{conf[k]}: {v[args.base]}" for k, v in res.json().items()]))
    else:
        print(f"Error fetching data: {res.json()}")
