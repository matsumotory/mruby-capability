assert("Capability.new") do
  cap = Capability.new
  assert_true cap.is_a?(Capability)
end
