setup() {
  PATH=$(pwd):$PATH

  mkdir sandbox; cd sandbox
}

teardown() {
  cd .. && rm -rf sandbox
}

@test "gud-init should create an empty, valid git repo" {
  gud-init
  run git status

  [ "$status" -eq 0 ]
	[ "${lines[0]}" = "On branch master" ]
	[ "${lines[1]}" = "No commits yet" ]
	[ "${lines[2]}" = 'nothing to commit (create/copy files and use "git add" to track)' ]
}
