## Working with Tmux

#### 1) Install

```sh
$ sudo apt install -y tmux
``` 

#### 2) Start Tmux

```sh
$ tmux
``` 

#### 3) Help

```sh
$ Ctrl+b ?
```

#### 4) Sessions

```sh
$ tmux new						// Create session
$ tmux new -s <session-name>				// Create session with a name
$ Ctrl+b d						// Detach from current session
$ tmux ls
$ tmux attach-session -t <session-no|session-name>	// Attach to session
$ tmux rename-session -t <session-no|session-name>	// Rename session
$ tmux kill-session -t <session-no|session-name>	// Kill session
``` 

#### 5) Windows and Panes

Creating windows and panes
```sh
$ Ctrl+b c 		// Create a new window (with shell)
$ Ctrl+b w 		// Choose window from a list
$ Ctrl+b , 		// Rename the current window
```

Spliting panes
```sh
$ Ctrl+b % 		// Split current pane horizontally into two panes
$ Ctrl+b " 		// Split current pane vertically into two panes
``` 

Navigating between windows and panes
```sh
$ Ctrl+b <window-no|window-name>	// Switching to <window-no|window-name>
$ Ctrl+b o 		// Go to the next pane
$ Ctrl+b key-up		// Go to the up pane
$ Ctrl+b key-left	// Go to the left pane
$ Ctrl+b ; 		// Toggle between the current and previous pane
```

Closing windows and panes
```sh
$ Ctrl+b x 		// Close the current pane or window
$ exit			// Idem
```


**Reference:**
- [https://linuxize.com/post/getting-started-with-tmux/](https://linuxize.com/post/getting-started-with-tmux/)

