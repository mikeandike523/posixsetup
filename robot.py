import re
import os
import time
import subprocess
import tempfile

import click
import pexpect
from termcolor import colored

class BadTableError(Exception):
    pass

def split_two_column_table(text):
    # Step 0: Remove blank lines
    lines = [line.strip() for line in text.replace("\r\n","\n").splitlines() if line.strip()]

    # Step 1: Find the largest consistent center whitespace
    min_whitespace_length = 0
    for line in lines:
        matches = re.finditer(r'^.*\S(\s+)\S.*?', line)
        line_largest_match_text= ""
        if matches:
            for match in matches:
                match_text = match.group(1)
                if "\t" in match_text:
                    raise BadTableError("Found a tab in the center whitespace")
                if len(match_text) > len(line_largest_match_text):
                    line_largest_match_text = match_text
        whitespace_length = len(line_largest_match_text)
        if whitespace_length < min_whitespace_length or min_whitespace_length == 0:
            min_whitespace_length = whitespace_length
    result = []
    for line in lines:
        match = re.match(r"^(.*)(\S) {"+str(min_whitespace_length)+r"} *(\S)(.*)$", line)
        if match:
            left = match.group(1) + match.group(2)
            right = match.group(3) + match.group(4)
            result.append([
                left.strip(),
                right.strip()
            ])

    return result

def run_and_expect(command, pairs):
    # Create a temporary directory
    temp_dir = tempfile.mkdtemp()
    # Create a temporary log file in the temporary directory
    log_file = tempfile.mkstemp(dir=temp_dir)[1]

    # Start tailing the log file in a subprocess
    tail_process = subprocess.Popen(["tail", "-f", log_file])

    # Open the log file for writing
    with open(log_file, "wb") as logfile:
        child = pexpect.spawn(
            command[0],
            command[1:],
            timeout=60*60*1000,
            logfile=logfile
        )
        while child.isalive():
            index = child.expect([p[0] for p in pairs]+[pexpect.EOF, pexpect.TIMEOUT])
            if index >= len(pairs):
                if index - len(pairs) == 0:
                    print(colored("Process complete","green"))
                if index - len(pairs) == 1:
                    print(colored("The process has timed out","red"))
                    exit(1)
            else:
              child.sendline(pairs[index][1])

        child.close()

    # Wait for a short duration to allow tail process to capture final updates
    time.sleep(0.1)
    # Terminate the tail process
    tail_process.terminate()

    # Clean up temporary directory and file
    subprocess.run(["rm", "-rf", temp_dir])

@click.command()
def main():
    # running as sudo
    os.chdir(os.path.dirname(os.path.realpath(__file__)))
    with open('patterns.txt', encoding="utf-8") as f:
        pattern_table_text = f.read()
    pattern_table = split_two_column_table(pattern_table_text)
    for i in range(len(pattern_table)):
        if pattern_table[i][1] == "<PASSWORD>":
            pattern_table[i][1] = click.prompt("Enter your password",hide_input=True)
        if pattern_table[i][1] == "<BLANK>":
            pattern_table[i][1] =""
        pattern_table[i][0] = "(?i)"+pattern_table[i][0]
        
    run_and_expect(["/bin/bash","wslsetup.sh"], pattern_table)
if __name__ == '__main__':
    main()