@test "ensures golang is installed on the PATH" {
  run which go
  [ "$status" -eq 0 ]
}
