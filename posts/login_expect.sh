set timeout 3

spawn ssh udev

expect {
  "Enter PIN for 'Key For PIV Authentication (PIT':" {
    send "pincode-here\r"
  }
  timeout {
    send "Expect timed out in ~/udev.sh"
  }
}

expect {
  "Password for james.m.pittard.ctr@AC2SP.ARMY.MIL:" { 
    send "passcode here\r"
  }
  timeout {
    # continue without providing password
  } 
}

interact
