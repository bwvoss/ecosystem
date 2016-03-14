package coordinator

type CommitLog [][]byte

func (commitLog *CommitLog) AppendCommit(commit []byte) error {
	*commitLog = append(*commitLog, commit)
	return nil
}

func (commitLog *CommitLog) LatestCommit() []byte {
	return (*commitLog)[0]
}
