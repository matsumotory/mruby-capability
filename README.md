# Linux Capability Class for mruby
- mruby linux capability class.

## install by mrbgems
 - add conf.gem line to `build_config.rb`
```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :git => 'https://github.com/matsumoto-r/mruby-capability.git'
end
```

## example

```ruby
 #
 # Set identifiers
 #
 # CAP_EFFECTIVE   0
 # CAP_PERMITTED   1
 # CAP_INHERITABLE 2

 #
 # These are the states available to each capability
 #
 # CAP_CLEAR 0
 # CAP_SET   1

 #
 # POSIX-draft defined capabilities.
 #
 # CAP_CHOWN             0
 # CAP_DAC_OVERRIDE      1
 # CAP_DAC_READ_SEARCH   2
 # CAP_FOWNER            3
 # CAP_FSETID            4
 # CAP_KILL              5
 # CAP_SETGID            6
 # CAP_SETUID            7
 # CAP_SETPCAP           8
 # CAP_LINUX_IMMUTABLE   9
 # CAP_NET_BIND_SERVICE  10
 # CAP_NET_BROADCAST     11
 # CAP_NET_ADMIN         12
 # CAP_NET_RAW           13
 # CAP_IPC_LOCK          14
 # CAP_IPC_OWNER         15
 # CAP_SYS_MODULE        16
 # CAP_SYS_RAWIO         17
 # CAP_SYS_CHROOT        18
 # CAP_SYS_PTRACE        19
 # CAP_SYS_PACCT         20
 # CAP_SYS_ADMIN         21
 # CAP_SYS_BOOT          22
 # CAP_SYS_NICE          23
 # CAP_SYS_RESOURCE      24
 # CAP_SYS_TIME          25
 # CAP_SYS_TTY_CONFIG    26
 # CAP_MKNOD             27
 # CAP_LEASE             28
 # CAP_AUDIT_WRITE       29
 # CAP_AUDIT_CONTROL     30
 # CAP_SETFCAP           31
 # CAP_MAC_OVERRIDE      32
 # CAP_MAC_ADMIN         33
 # CAP_SYSLOG            34
 # CAP_WAKE_ALARM        35
 # CAP_BLOCK_SUSPEND     36
 # CAP_COMPROMISE_KERNEL 37
 #
 c = Capability.new
 cap = [ Capability::CAP_SETUID, Capability::CAP_SETGID ]

 # get cap from own thread into instance

 c.set Capability::CAP_PERMITTED, cap
 c.set_flag Capability::CAP_EFFECTIVE, cap, Capability::CAP_SET

 # change uid gid by not root user

 c.get_proc
 c.clear Capability::CAP_EFFECTIVE, cap
 c.set_flag Capability::CAP_PERMITTED, cap, Capability::CAP_CLEAR
 ```

# License
under the MIT License:

* http://www.opensource.org/licenses/mit-license.php


