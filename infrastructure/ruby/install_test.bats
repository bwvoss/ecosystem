@test "installs ruby version 2.3.0" {
  run ruby -v
  [[ "$output" =~ "2.3.0" ]]
}
