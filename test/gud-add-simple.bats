setup() {
  PATH=$(pwd):$PATH
  SANDBOX=$(mktemp -d)
  cd $SANDBOX

  git init
}

teardown() {
  rm -rf $SANDBOX
}

@test "gud-add-simple should create a new blob object" {
  echo 'a' > a.txt
  run gud-add-simple a.txt

  # Command outputs that it created the file. Since 'a' always has the same
  # SHA, we can hardcode the file path.
  [ "$status" -eq 0 ]
	[ "${output}" = "Wrote blob .git/objects/78/981922613b2afb6025042ff6bd878ac1994e85" ]

  # File exists
  run ls ".git/objects/78/981922613b2afb6025042ff6bd878ac1994e85"

  [ "$status" -eq 0 ]
}

@test "gud-add-simple should create a new index when it adds the first file" {
  echo 'a' > a.txt
  gud-add-simple a.txt
  run cat .git/gud_index

	[ "${output}" = '[["100644","a.txt","78981922613b2afb6025042ff6bd878ac1994e85"]]' ]
}

@test "gud-add-simple adds files to an existing index" {
  a_index_entry='["100644","a.txt","78981922613b2afb6025042ff6bd878ac1994e85"]'
  b_index_entry='["100644","b.txt","61780798228d17af2d34fce4cfbdf35556832472"]'

	echo "[${a_index_entry}]" > .git/gud_index

  echo 'b' > b.txt
  gud-add-simple b.txt

  run cat .git/gud_index
	expected="[${a_index_entry},${b_index_entry}]"

	[ "${output}" = ${expected} ]
}
