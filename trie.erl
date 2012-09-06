-module(trie).

-export([new/0, store/3, next/2, value/2]).

new () ->
	{[], []}.

% Adds or updates an object with the given key and returns the new trie.
store ([], Object, {TrieDict, _}) ->
	{TrieDict, Object};
store ([Elem | StringTail], Object, {TrieDict, Slot}) ->
	case orddict:find (Elem, TrieDict) of
		{ok, Subtrie} ->
			{orddict:store (Elem, store (StringTail, Object, Subtrie), TrieDict), Slot};
		error ->
			{orddict:store (Elem, store (StringTail, Object, new ()), TrieDict), Slot}
	end.

% Get the next trie from the key.
next ([], {TrieDict, Slot}) ->
	{TrieDict, Slot};
next ([Elem | StringTail], {TrieDict, _}) ->
	case orddict:find (Elem, TrieDict) of
		{ok, Subtrie} -> 
			next (StringTail, Subtrie);
		error -> undefined
	end.

% Get value of key.
value(Key, Trie) ->
	case next(Key, Trie) of
		{_, Value} ->
			Value;
		_ ->
			undefined
	end.