#
# use mruby-process, mruby-sleep, mruby-capability
#

c = Capability.new
cap = [Capability::CAP_SETUID, Capability::CAP_SETGID]
c.set Capability::CAP_PERMITTED, cap

pid = Process.fork {
  loop do
    c.get_proc
    c.set Capability::CAP_EFFECTIVE, cap
    uid = Random::rand(1000)
    puts "setuid #{uid}"
    c.setuid(uid)
    puts "getuid #{c.getuid}"
    sleep 5
    c.clear Capability::CAP_EFFECTIVE, cap
  end
}

Process.waitpid pid
