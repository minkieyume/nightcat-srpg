extends Node

func should_sync():
	return MPIO.mpc.mode == MPIO.mpc.PlayMode.Online
