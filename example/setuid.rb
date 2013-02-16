#
# use mruby-process, mruby-random, mruby-capability
#

c = Capability.new
cap = [Capability::CAP_SETUID, Capability::CAP_SETGID]
c.set Capability::CAP_PERMITTED, cap

pid = Process.fork {
  loop do
    c.get_proc
    c.set Capability::CAP_EFFECTIVE, cap
    sleep 2
    uid = Random::rand(1000)
    puts uid
    c.setuid(uid)
    c.clear Capability::CAP_EFFECTIVE, cap
  end
}

Process.waitpid pid
