package coordinator

import "errors"

type CommitLog interface {
	AppendCommit(commit []byte) error
	LatestCommit() []byte
}

type InMemoryCommitLog [][]byte

func (commitLog *InMemoryCommitLog) AppendCommit(commit []byte) error {
	*commitLog = append(*commitLog, commit)
	return nil
}

func (commitLog *InMemoryCommitLog) LatestCommit() []byte {
	return (*commitLog)[0]
}

type ErrorCommitLog [][]byte

func (commitLog *ErrorCommitLog) AppendCommit(commit []byte) error {
	return errors.New("Failure of Commit Log")
}

func (commitLog *ErrorCommitLog) LatestCommit() []byte {
	return (*commitLog)[0]
}
