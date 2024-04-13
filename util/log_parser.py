#!/usr/bin/env python3

import argparse
import re
from enum import Enum
from pathlib import Path


class MessageType(Enum):
    ERROR = 0
    CRITICAL_WARNING = 1
    WARNING = 2

    @classmethod
    def encode(cls, string):
        return {
            "ERROR": MessageType.ERROR,
            "CRITICAL WARNING": MessageType.CRITICAL_WARNING,
            "WARNING": MessageType.WARNING,
        }[string]


class Message:
    def __init__(self, type: MessageType, id: str, text: str):
        self.type = type
        self.id = id
        self.text = text


class Messages:
    def __init__(self):
        self._messages = {
            MessageType.ERROR: [],
            MessageType.CRITICAL_WARNING: [],
            MessageType.WARNING: [],
        }

    def append(self, message: Message):
        self._messages[message.type].append(message)

    def has_error(self):
        return self._error

    def ignore(self, ignores: list):
        for ignore in ignores:
            attr, regex = ignore.split("=")
            for typ, messages in self._messages.items():
                self._messages[typ] = [
                    m for m in messages if not regex in getattr(m, attr)
                ]

    def __repr__(self):
        string = []
        for typ, messages in self._messages.items():
            for message in messages:
                string.append(f"{typ.name}: [{message.id}] {message.text}")
        return "\n".join(string)


re_warn_or_error = re.compile(
    """
    (WARNING|ERROR|CRITICAL\sWARNING):\s
    \[(.+?)\]\s
    (.*)
    """,
    re.X,
)


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("filename", help="the log file to parse")
    parser.add_argument("--ignore", nargs="+", help="ignore a warning")
    return parser.parse_args()


def main():
    messages = Messages()

    args = get_args()
    logfile = Path(args.filename)

    with logfile.open() as f:
        for line in f:
            line = line.rstrip()
            if match := re_warn_or_error.match(line):
                (typ, id, msg) = match.groups()
                messages.append(Message(MessageType.encode(typ), id, msg))

    if args.ignore:
        messages.ignore(args.ignore)
    print(messages)


if __name__ == "__main__":
    main()
