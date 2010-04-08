;;; coremacs.el --- Extensible framework that integrates CORE and Emacs

;; Copyright (C) 2008  Jason Dunsmore

;; Author: Jason Dunsmore <jason.dunsmore@rackspace.com>
;; Keywords: local, abbrev, convenience, files, wp

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Summary
;; -------

;; Coremacs provides a set of functions that allow Rackers to create
;; and post all ticket updates from Emacs using ticket-mode and custom
;; templates.  Coremacs also provides an Emacs lisp interface to the
;; CORE XML-RPC API and interactive functions to query information
;; about the ticket from CORE.

;; Every ticket update is kept in a file in the tickets directory,
;; making the tickets directory a convenient way to track your ticket
;; updates.  To find a ticket you posted earlier, type M-x
;; coremacs-ticket-history, click on the ticket, and type C-c C-j to
;; view the ticket in your web browser.

;; Over time, the tickets directory will become a searchable database
;; of your past ticket updates.  Type M-x coremacs-ticket-grep and the
;; string you'd like to search for to search through your past ticket
;; updates.

;; If you're new to Emacs, I'd recommend going through the Emacs
;; tutorial to get the most from Coremacs.  You can either click on
;; the "Emacs Tutorial" link on the startup screen or go to the
;; following URL for a gentler introduction:
;; http://www.gnu.org/software/emacs/tour/

;; Installation
;; ------------

;; Put coremacs.el, xml-rpc.el, and password.el somewhere in your
;; ~/.emacs.d directory:

;; $ cd ~/.emacs.d
;; $ wget http://work.j4y.net/coremacs/coremacs.el
;; $ wget http://work.j4y.net/coremacs/password.el
;; $ wget http://cvs.savannah.gnu.org/viewvc/*checkout*/emacsweblogs/weblogger/lisp/xml-rpc.el

;; ..and make sure the following is in your ~/.emacs file:

;; (add-to-list 'load-path "~/.emacs.d")

;; Coremacs has only been tested on GNU Emacs 22.  Please let me know
;; if you test Coremacs on other versions of Emacs.

;; Configuration
;; -------------

;; The following is a sample configuration that should be customized
;; for your environment and placed in your .emacs file.  To view the
;; documentation for any configuration variable, type:
;; C-h v coremacs-variable

;; To get your contact ID, type:
;; M-x coremacs-sso-id RET joe.racker

;; (require 'coremacs)
;; (add-to-list 'auto-mode-alist '(".*tickets/" . ticket-mode))
;; (setq coremacs-ticket-path "~/tickets/")
;; (setq browse-url-browser-function 'browse-url-firefox)
;; (setq coremacs-user "joe.racker")
;; (setq coremacs-contact-id 123456)
;; (setq coremacs-autologin "alng.py")
;; (setq coremacs-terminal "xterm")
;; (setq coremacs-password-expiry nil)
;; (setq coremacs-public-greeting "Hi")
;; (setq coremacs-public-greeting-noname "Hello")
;; (setq coremacs-public-signature "
;;
;; Best regards,
;; Joe Racker
;; GNU/Linux System Administrator
;; Rackspace Managed Support
;; Toll Free: 800-961-4454")
;; (setq coremacs-private-signature "
;;
;; Thanks,
;; Joe Racker")

;; Pre-defined keybindings
;; -----------------------

;; The following keybindings are available when in a ticket buffer.
;; Type "C-h f coremacs-function" for the function documentation.

;; C-c C-a		coremacs-browse-account
;; C-c C-c		coremacs-ticket-post
;; C-c C-e		coremacs-browse-plesk
;; C-c C-j		coremacs-browse-current-ticket
;; C-c C-k		coremacs-buffers-clean-up
;; C-c C-l		coremacs-browse-history
;; C-c C-p		coremacs-browse-servers-pass
;; C-c C-r		coremacs-browse-rackwatches
;; C-c C-s		coremacs-browse-servers
;; C-c C-t		coremacs-launch-ticket-shells
;; C-c C-w		coremacs-browse-rackwatch-configs

;; Suggested custom global keybindings
;; -----------------------------------

;; A custom keybinding can be created for any interactive function.
;; The following are examples that can be placed in your .emacs file.

;; Cycle between all open tickets that haven't been posted yet:

;; (global-set-key (kbd "<f2>") (lambda ()
;; 			         (interactive)
;; 			         (coremacs-buffers-next t)))

;; Cycle between all tickets, posted and not posted:

;; (global-set-key (kbd "S-<f2>") (lambda ()
;; 				   (interactive)
;; 				   (coremacs-buffers-next)))

;; Create a public ticket buffer:

;; (global-set-key (kbd "<f12>") 'coremacs-public-blank)

;; Create a private ticket buffer:

;; (global-set-key (kbd "S-<f12>") 'coremacs-private-blank)

;; Open a shell for a server.  Useful if you don't have a ticket
;; buffer open yet or if you only want to open a shell for one out of
;; many servers associated with a ticket.

;; (global-set-key (kbd "S-<f3>") 'coremacs-open-server-shell)

;; Typical workflow
;; ----------------

;; For a typical public ticket update, I do the following steps:
;; 1) Select the ticket number in the address bar.
;; 2) In Emacs, type "f12 S-insert RET" (S-insert will paste the
;;    X-selection buffer)
;; 3) Type the customer's name.
;; 4) Write the ticket update, using my pre-defined Emacs abbrevs and
;;    "M-x coremacs-ticket-grep" to search for previous similar
;;    tickets.
;; 5) Use the functions in the "pre-defined keybindings" section above
;;    to launch terminals for servers associated with ticket or to
;;    find various information about the account or server.
;; 6) Type "C-c C-c" to post the ticket to CORE.

;; For a typical computer provisioning alert, I do the following:
;; 1) Select the ticket number in the address bar.
;; 2) In Emacs, type "S-f12 S-insert RET"
;; 3) Type "C-c C-t" to launch a terminal for the server.
;; 4) Paste the output of the commands in the ticket buffer.
;; 5) Type "C-c C-c" to post the ticket to CORE.
;; 6) Type "M-x coremacs-private-ptr RET M-p RET C-c C-c" to create a
;;    PTR request (see below).

;; Currently, Coremacs can only post updates to existing tickets.  To
;; post to an new ticket, create a new ticket in CORE with a `.' in
;; the body and can use the ticket number to post the ticket from
;; Coremacs.

;; Extending Coremacs
;; ------------------

;; The following functions demonstrate how easy it is to create new
;; functions that extend the functionality of Coremacs.

;; This function creates a request for NetSec to add a PTR record to a
;; newly-provisioned server.

;; (defun coremacs-private-ptr (ticket)
;;   "Private ticket requesting NetSec to configure PTR record."
;;   (interactive (list (coremacs-ticket-number-read)))
;;   (coremacs-private
;;    (insert "NetSec,
;;
;; Please setup the following PTR record:
;;
;; " (coremacs-computer-ptr (first (coremacs-ticket-servers ticket))))))

;; This function opens a new browser tab for each server in a ticket.

;; (defun coremacs-browse-rackwatches ()
;;   "In a ticket buffer, open Rackwatch histories for each server."
;;   (interactive)
;;   (coremacs-do-ticket-servers
;;    server
;;    (browse-url (concat coremacs-rackwatch-prefix server))))

;; Please send your extensions to jason.dunsmore@rackspace.com so they
;; can be included in the next Coremacs release.


;;; Code:

(require 'cl)
(require 'xml-rpc)
(require 'password)



;;;; Configuration variable documentation.
;;;; All variables in this section should be set in ~/.emacs file.

(defvar coremacs-ticket-path nil
  "Directory where tickets are stored.")

(defvar coremacs-user nil
  "SSO username used to login to CORE.")

(defvar coremacs-contact-id nil
  "Contact ID number for SSO login.

Necessary to eliminate an extra XMLRPC call every time a new
token is needed.  To get your contact ID, type:

M-x coremacs-sso-id RET joe.racker")

;; (defvar coremacs-info-file nil
;;   "Path to Coremacs info file.  Required by coremacs-info function.")

(defvar coremacs-autologin nil
  "Autologin script that Coremacs should use to login to servers.
Can be a full path or just the name of the executable if it's in
the user's PATH.  alng.py works nicely and is available at
https://gforge.rackspace.com/gf/project/alng/")

(defvar coremacs-terminal nil
  "X terminal that Coremacs should use to login to servers.
Currently, only rxvt and xterm are supported.")

(defvar coremacs-default-queue nil
  "Ticket queue that new tickets are in by default.")

(defvar coremacs-password-expiry nil
  "How many seconds passwords are cached, or nil to disable expiring.")

(setq password-cache-expiry coremacs-password-expiry)

(defvar coremacs-public-greeting nil
  "Greeting for template for public tickets where name was specified.
Examples: \"Hi\", \"Hello\", \"Guten tag\"")

(defvar coremacs-public-greeting-noname nil
  "Greeting for template for public tickets where no name was specified.")

(defvar coremacs-public-signature nil
  "Signature for public tickets.")

(defvar coremacs-private-signature nil
  "Signature for private tickets.")


;;;; Mode definition

(define-derived-mode ticket-mode org-mode "Ticket"
  "Major mode for editing CORE tickets."
  (interactive)

  ;; Initialize
  (kill-all-local-variables)

  ;; Configure local keybindings
  (define-key ticket-mode-map (kbd "C-c C-a") 'coremacs-browse-account)
  (define-key ticket-mode-map (kbd "C-c C-c") 'coremacs-ticket-post)
  (define-key ticket-mode-map (kbd "C-c C-d") 'coremacs-browse-dnstool)
  (define-key ticket-mode-map (kbd "C-c C-e") 'coremacs-browse-plesk)
  (define-key ticket-mode-map (kbd "C-c C-f") 'coremacs-grep)
  (define-key ticket-mode-map (kbd "C-c C-j") 'coremacs-browse-current-ticket)
  (define-key ticket-mode-map (kbd "C-c C-k") 'coremacs-buffers-clean-up)
  (define-key ticket-mode-map (kbd "C-c C-l") 'coremacs-browse-history)
  (define-key ticket-mode-map (kbd "C-c C-p") 'coremacs-browse-servers-pass)
  (define-key ticket-mode-map (kbd "C-c C-r") 'coremacs-browse-rackwatches)
  (define-key ticket-mode-map (kbd "C-c C-w") 'coremacs-browse-rackwatch-configs)
  (define-key ticket-mode-map (kbd "C-c C-s") 'coremacs-insert-screen-exchange)
  (define-key ticket-mode-map (kbd "C-c C-t") 'coremacs-launch-ticket-shells)
;;  (define-key ticket-mode-map [mouse-1] 'coremacs-visit-url)
  (use-local-map ticket-mode-map)

  ;; Set mode variables
  (setq major-mode 'ticket-mode
	mode-name "Ticket"
	local-abbrev-table ticket-mode-abbrev-table)

  ;; Default configuration
  (setq abbrev-mode t)
  (setq indent-tabs-mode nil)
  (visual-line-mode t)
;;  (xterm-mouse-mode -1)

  (run-hooks 'ticket-mode-hook))


;;;; Utility functions

(defun assocdr (key list)
  "Return the cdr of the first element of LIST whose car equals KEY."
  (cdr (assoc key list)))

(defun buffer-list-saved ()
  "Return a list of all existing live buffers that haven't been
modified since they were last written to disk."
  (let (buffers)
    (dolist (buffer (buffer-list) buffers)
      (unless (buffer-modified-p buffer)
	(push buffer buffers)))))

(defun buffer-writable-p (buffer-or-name)
  "Returns T if buffer is writable, NIL if not."
  (not (buffer-local-value 'buffer-read-only (get-buffer buffer-or-name))))

(defun ticket-mode-p (buffer-or-name)
  "Returns T if buffer is writable, NIL if not."
  (equal (buffer-local-value 'mode-name (get-buffer buffer-or-name)) "Ticket"))

(defun file->string (name &optional func)
  "Convert a file into a string"
  (interactive "fFile name : ")
  (let ((filename (expand-file-name name)))
    (if (not (file-readable-p filename))
	nil
      (let ((buf (create-file-buffer filename))
	    ret)
	(save-excursion
	  (set-buffer buf)
	  (insert-file-contents filename)
	  (if func (funcall func))
	  (setq ret (buffer-string)))
	(kill-buffer buf)
	ret))))

(defun http-get-string (url)
  (http-get url)
  (sleep-for 0.5)
  (set-buffer (concat "*HTTP GET " url " *"))
  (buffer-string))


;;;; General regular expressions and URL prefixes

(defconst coremacs-ticket-regexp "[0-9]\\{6\\}-[0-9]\\{5\\}"
  "Matches ticket number.  Example: 080808-03283")

(defconst coremacs-ticket-url-prefix "https://core.rackspace.com/py/ticket/view.pt?ref_no="
  "Prefix for CORE's ticket URL.")

(defconst coremacs-ticket-history-prefix
  "https://core.rackspace.com/py/ticket/accountHistory.pt?status=all&account_number="
  "Prefix for CORE's ticket history URL.")

(defconst coremacs-server-prefix "https://core.rackspace.com/?computer_number="
  "Prefix for CORE's server URL.")

(defconst coremacs-server-pass-prefix "https://core.rackspace.com/py/computer/summary.pt?show_secrets=1&computer_number="
  "Prefix for CORE's server pass URL.")

(defconst coremacs-domain-prefix "https://core.rackspace.com/py/dnstool/showzone.pt?zone="
  "Prefix for CORE's zone file URL.")

(defconst coremacs-account-prefix "https://core.rackspace.com/ACCT_main_workspace_page.php?account_number="
  "Prefix for CORE's account URL.")

(defconst coremacs-rackwatch-prefix "https://core.rackspace.com/py/rackwatch/index.pt?computer_number="
  "Prefix for CORE's Rackwatch URL.")

(defconst coremacs-rackwatch-config-prefix "https://core.rackspace.com/py/computer/rackwatch-services.pt?computer_number="
  "Prefix for CORE's Rackwatch configuration URL.")

(defconst coremacs-dnstool-prefix "https://dcx.rackspace.com/dns_manager/zones?"
  "Prefix for DNS Tool URL.  Variables are \"criterion\" and \"account_number\".")


;;;; XMLRPC functions

;;; Lisp interface to essential CORE XMLRPC functions

(defconst coremacs-url "https://ws.core.rackspace.com/xmlrpc/"
  "CORE's base XML-RPC URL.")

;; Testing: comment out coremacs-url definition above and uncomment following line,
;; then M-x eval-buffer
;;(setq coremacs-url "https://strata31.demo3.core.rackspace.com/xmlrpc/")

(defconst coremacs-computer-url (concat coremacs-url "Computer")
  "URL for CORE's computer-related XML-RPC functions.")

(defconst coremacs-ticket-url (concat coremacs-url "Ticket")
  "URL for CORE's ticket-related XML-RPC functions.")

(defconst coremacs-account-url (concat coremacs-url "Account")
  "URL for CORE's account-related XML-RPC functions.")

(defconst coremacs-contact-url (concat coremacs-url "Contact")
  "URL for CORE's contact-related XML-RPC functions.")

(defconst coremacs-network-url (concat coremacs-url "Network")
  "URL for CORE's network-related XML-RPC functions.")

(defconst coremacs-auth-url (concat coremacs-url "Auth")
  "URL for CORE's authentication XML-RPC functions.")

(defvar coremacs-token nil
  "Authentication token for CORE's XML-RPC interface.")

(defun coremacs-new-token ()
  "Prompt for SSO password and then request a new XML-RPC token.
If password is correct, cache password for number of seconds
defined by password-cache-expiry.

systemLogin: This allows remote systems to get a login token for using CORE via authenticated XMLRPC services.

    It is intended for remote systems within rackspace to use to login to CORE.

    Arguments:
    login - (string) username to login
    password - (string) password

    returns:  (string) login token

    Faults:
      4 - on bad login/password info.

    Note: this method will fault (throw an exception) on failure, such as a bad password."
  (let ((pass (password-read "SSO Password? " "coremacs-pass")))
    (unless coremacs-user
      (error "coremacs-user variable not set"))
    (unless (setq coremacs-token
		  (xml-rpc-method-call coremacs-auth-url 'systemLogin
				       coremacs-user pass))
      (password-cache-remove "coremacs-pass")
      (coremacs-new-token))
    (when (coremacs-valid-token-p coremacs-token)
      (password-cache-add "coremacs-pass" pass))))

(defun coremacs-token-valid? (coremacs-token)
  "isTokenValid: This checks to see if a login token is still valid.

    Persistant processes that access CORE via XMLRPC, or ones that can remember the
    login token in some way, can keep their token around. This method lets them check if
    the token is still good, or if they need to login again.

    Arguments:
    login_token - (string) a login token returned from one of the Login functions above.

    returns: 1 if token is valid,  0 otherwise."
  (xml-rpc-method-call coremacs-auth-url 'isTokenValid coremacs-token))

(defun coremacs-xmlrpc (url &rest args)
  "Wrapper for CORE XML-RPC call."
  (coremacs-freshen-token)
  (let ((url (concat url "/::session_id::" coremacs-token)))
    (apply 'xml-rpc-method-call url args)))

(defun coremacs-computer-admin-login (server)
  "getComputerAdminLogin: Returns administrative (root) username and password to login to a SERVER.

    This will return the administrator username and password.

    Argument:
        computer_number :  (int) computer number.

    returns:
        a list consisting of 2 strings. The first item is the username (i.e. 'root' or 'Administrator'), the second the password.
        For example: [ 'root', 'MyPasswdIsFoo' ]
            -or-     [ 'Administrator', 'b14hf00' ]

    Faults:
        2 - If user does not have permission to access server passwords
        5 - If passed a bad/nonexistant computer number"
  (second (coremacs-xmlrpc coremacs-computer-url 'getComputerAdminLogin server)))

(defun coremacs-computer-login (server)
  "getComputerLogin: Returns a username and password to login to a SERVER.

    This will return a username an password that can be used to login  to a given server.
    This may be a temporary one that expires after a time.

    Argument:
        computer_number :  (int) computer number.

    returns:
        a list consisting of 2 strings. The first item is the username, the second the password.
        For example: [ 'rack', 'MyPasswdIsFoo' ]
            -or-     [ '12345_aperson', 'b14hf00' ]

    Faults:
        2 - If user does not have permission to access server passwords
        5 - If passed a bad/nonexistant computer number
        7 - Could not receive login info from IdentityManager system"
  (second (coremacs-xmlrpc coremacs-computer-url 'getComputerLogin server)))

(defun coremacs-computer-login-info (server)
  "getComputerLoginInfo: Returns IP plus user, and Admin login info for SERVER.

    This will return all of the info needed to login to a server,
    namely a regular username/password, root/admin password, and
    the server's IP.

    Argument:
        computer_number :  (int) computer number.

    returns:
        A dictionary containing login info. The values in the dictionary are:
            username: (string) username for login to a regular account.
            password: (string) password for regular account
            admin_username: (string) username for admin account (i.e. 'root' or 'Admin')
            admin_password: (string) password for admin account
            primary_ip:  (string)  primary IP of server

    Faults:
        2 - If user does not have permission to access server passwords
        5 - If passed a bad/nonexistant computer number
        7 - Could not receive login info from IdentityManager system
            (if this is used for regular logins)"
  (coremacs-xmlrpc coremacs-computer-url 'getComputerLoginInfo server))

(defun coremacs-computer-details (server)
  "getDetailsByComputers: Returns a list of various details about SERVER.

        arguments:
           computer_list : ([int]) list of computer numbers
           lower_status : (int) (*optional*) lower bound status to query for. Default 3 (Received Contract)

        returns:
           A list of dictionary (assoc. array) values containing:
             'server': (int) the server number
             'server_name' : (str) the name of the server
             'status': (str) the status of the server
             'port' : (str) port (location) server plugged into
             'datacenter': (str) datacenter abbreviation (i.e. LON1, LON2, SAT2, etc)
             'primary_ip': (str) primary IP address
             'platform' : (str) the CORE platform (hardware + OS) of server
             'os' : (str) More specific description of OS (is available) (Same as 'kick:' on core kickstart page)
             'os_group' : (str) The OS name. Can be one of:
                     Linux
                     Microsoft Windows
                     Sun/Solaris
                     RAQ
                     BSD
                     Network
                     Misc
                     None
             'customer': (int) the account number
             'customer_name': (str) the name associated with the account
             'account_manager': (str) the AM (if assigned)
             'account_manager_id': (int) contact id # of the AM (if assigned) (0 if unassigned)
             'business_development': (str) the BDC (if assigned)
             'business_development_id': (int) contact id # of the BDC (if assigned) (0 if unassigned)
             'lead_tech': (str) team technical lead of the account
             'lead_tech_id': (int) contact id # of team technical lead of the account (0 if no tech)
             'segment' : (str) account segment name
             'due_date': (str) Due date for server build queue (None if no date)
             'offline_date': (str) When is this server scheduled to go offline? (None if no date)
             'team' : (str) name of the team assigned
             'emergency_instructions' : (str) device level emergency instructions
             'due_date': (str) Due date for server build queue (None if no date)
             'offline_date': (str) When is this server scheduled to go offline? (None if no date)
             'icon' : (str) absolute path for the image icon (from core.rackspace.com)
             'attached_devices' : (list of int) server numbers of devices behind current device
             'has_managed_storage' : (boolean) whether or not the device has managed storage as a server part (sku)"
  (coremacs-xmlrpc coremacs-computer-url 'getDetailsByComputers (list server)))

(defun coremacs-ticket-info (ticket)
  "getTicketInfo: Gets general information about a TICKET.

        Argument:
        ticket_number - (str) Ticket number to query

        returns: a dictionary (associative array) containing:
               { 'ticket_number': the ticket number,
                 'assignee': the assignee of the ticket,
                 'assignee_id': the contact id of the assignee,
                 'account_number': the account number,
                 'servers': list of server numbers that are listed in the ticket
                 'queue_id': the ID number of the queue
               }"
  (coremacs-xmlrpc coremacs-ticket-url 'getTicketInfo ticket))

(defun coremacs-tickets-status (ticket-list)
  "getTicketsStatus: Retrieves the statuses of a list of TICKET numbers.

    argument:
       ticket_list : ([str] - list of strings) list of ticket numbers

    returns:
       a list of dictionary values containing ticket numbers and statuses
       [{'ticket_number','status'}]

       raises 'Unable to load supplied ticket number' fault on error."
  (coremacs-xmlrpc coremacs-ticket-url 'getTicketsStatus ticket-list))

(defun coremacs-ticket-get-queues ()
  "getQueues: Gets all available Ticket queues.

        This method takes no arguments.

        returns: a dictionary (associative array) of Ticket queues,
                 The keys are the names, the values are the corresponding
                 ID's"
  (coremacs-xmlrpc coremacs-ticket-url 'getQueues))

(defun coremacs-ticket-list-queue-views ()
  "getAvailableQueueViews: Gets ticket queues/views.

        This method takes no arguments.

        returns: A dictionary that contains available queues/views and their
                 associated tags."
  (coremacs-xmlrpc coremacs-ticket-url 'getAvailableQueueViews))

(defun coremacs-ticket-queue-show (queue)
  "getTicketQueue: Gets the tickets in a specified QUEUE.

    Use getQueues() to get the id's of the queues you want

    argument:
        tag : (str) the tag value (obtained from getAvailableQueues)
            of the queue
        offset (optional): (int) view the next page; default size is 20
        sort_fields (optional): [(str)] fields to sort by
            List can contain any of:
                 Age, AccountNumber, SupportTeam, ReferenceNumber,
                 Created, Assignee_LastName, Assignee_FirstName, Queue,
                 Severity, Priority, Status, LastPublicResponseDate
            To reverse, append '_Desc' to the end of the name
              i.e.: Age_Desc
            Defaults are ['Priority_Desc','LastPublicResponse_Desc', 'Created']

    returns: a list of dictionary (associative array) values
             containing ticket information"
  (coremacs-xmlrpc coremacs-ticket-url 'getTicketQueue queue))

(defun coremacs-ticket-show-queue-awake (queue)
  "getTicketQueueAwake: Gets the tickets in a specified QUEUE that are awake.

    Use getQueues() to get the id's of the queues you want

    This method is identicat to getTicketQueue except the TicketWhere() is StatusType.AWAKE
    instead of StatusType.ALIVE

    argument:
        tag : (str) the tag value (obtained from getAvailableQueues)
            of the queue
        offset (optional): (int) view the next page; default size is 20
        sort_fields (optional): [(str)] fields to sort by
            List can contain any of:
                 Age, AccountNumber, SupportTeam, ReferenceNumber,
                 Created, Assignee_LastName, Assignee_FirstName, Queue,
                 Severity, Priority, Status, LastPublicResponseDate
            To reverse, append "_Desc" to the end of the name
              i.e.: Age_Desc
            Defaults are ['Priority_Desc','LastPublicResponse_Desc', 'Created']

    returns: a list of dictionary (associative array) values
             containing ticket information"
  (coremacs-xmlrpc coremacs-ticket-url 'getTicketQueueAwake queue))

(defun coremacs-ticket-add-message (ticket comment private)
  "addMessage: Add a COMMENT to a TICKET.

    arguments:
       ticket_number : (str) number of the ticket
       text          : (str) text body of the message
       requestor     : (str or int) Contact object or contact ID
                       number of requestor
       is_private    : (boolean) Is this message private/internal?
       send_message_text : (boolean) Send this message text in the email?

    returns: str('success') on completion"
  (coremacs-xmlrpc coremacs-ticket-url 'addMessage ticket comment
			coremacs-contact-id private 0))

(defun coremacs-ticket-create (account subject comment private)
  "createTicket: Creates an External (regular customer) Ticket.

        Arguments:
        queue - (int) ID number of queue to create ticket in.
        severity - (int) ID number of severity of ticket.
        subcategory - (int) ID number of subcategory of ticket.
        subject - (string) Subject of ticket.
        initial_message - (string) Text of initial message for ticket.
        is_private - (boolean) If true, ticket is made private
        private_first_message - (boolean) If true, the initial message is made private
        recipients - (list, (aka Array) of int) list of CORE Contact ID's
                     of the recipients for this ticket.
        requester - (int) CORE Contact ID of the requester of this ticket.
        account - (int) Reference number of customer account this ticket is for.
        computer_list - (list, (aka Array) of int) list of computer numbers
                        this ticket is for (may be empty)
        assignee - (int) contact id of assignee
        send_message_text - (boolean) include comment in email
        status - (int) status id. It defaults to the New status.
        contact_email_type - (int) contact_email_type id. Default is PRIMARY
                email address, but Rackwatch email address is also possible.
        priority - (int) priority id

        returns: (string) ticket number of new ticket."
  (coremacs-xmlrpc coremacs-ticket-url 'createTicket
		   coremacs-default-queue
		   1        ; 1 = Normal, 2 = urgent, 3 = Emergency
		   121      ; "Other" subcategory
		   subject
		   comment
		   private
		   private
		   (list coremacs-contact-id)
		   coremacs-contact-id
		   account
		   ""
		   coremacs-contact-id
		   0))

(defun coremacs-subticket-create (ticket subject comment private)
  "createSubTicket: Creates a new SubTicket for a given Ticket.

       Arguments:
       ticket_number - (string) the Ticket reference number of the Ticket to create a
                       subticket of.
       subject - (string) Subject of the subticket.
       initial_message - (string) Text of initial message for the sub-ticket
       queue [optional] - (int) ID number of queue to create sub-ticket in.
                          (defaults to same queue as superticket)
       computer_list - (list, (aka Array) of int) list of computer numbers
                         this ticket is for (may be empty). Defaults to empty
       severity [optional] - (int) ID number of severity of sub-ticket.
                          (defaults to same as superticket)
       is_public [optional] - (boolean) If true, ticket is made public.
                           (defaults to False)
       computer_list [optional] - (list, (aka Array) of int) list of computer numbers
                         this ticket is for (may be empty). Defaults to empty
       subcategory [optional] - (integer) subcategory of the sub-ticket.
                           (defaults to the subcategory of the master ticket)
       is_scheduled_service [optional] - (boolean) If true, ticket is a scheduled_service
                            ticket. (defaults to False)

       returns: (string) ticket number of new sub-ticket."
  (coremacs-xmlrpc coremacs-ticket-url 'createSubTicket
		   ticket
		   subject
		   comment
		   1        ; 1 = Normal, 2 = urgent, 3 = Emergency
		   nil
		   1
		   private))

(defun coremacs-contact-get-id (sso)
  "getContactForEmployee: Returns CORE contact ID # for a given employee SSO username.

        Arguments:
	username - (string) Username (i.e. login name) of employee to look up.

	returns: (int) CORE contact ID of employee.

	Faults:
	   5 - if no employee exists with that username."
  (coremacs-xmlrpc coremacs-contact-url 'getContactForEmployee sso))

(defun coremacs-ticket-close (ticket)
  "closeTicket: Close out a ticket

    Sets the ticket passed to 'customer_solved_status'

    argument:
       ticket_number : (str) the ticket number to close

    returns: str('success') on completion
       raises 'cannot load ticket' Fault on failure to load."
  (coremacs-xmlrpc coremacs-ticket-url 'closeTicket ticket))


;;; More specialized XMLRPC functions

(defun coremacs-sso-id (sso)
  (interactive "sSSO username: ")
  (let ((id (number-to-string (coremacs-contact-get-id sso))))
    (message (concat "The contact ID for your SSO is: " id))))

(defun coremacs-valid-token-p (coremacs-token)
  "Test whether or not COREMACS-TOKEN token is valid."
  (let ((valid? (coremacs-token-valid? coremacs-token)))
    (if (equal valid? 0) nil t)))

(defun coremacs-freshen-token ()
  "If token exists, see if it's valid.  If it's not valid or
doesn't exist, request a new token."
  (if coremacs-token
      (unless (coremacs-valid-token-p coremacs-token)
	(coremacs-new-token))
    (coremacs-new-token)))

(defun coremacs-computer-ptr (server)
  "Returns a string of what a server's PTR record should be."
  (let* ((info (coremacs-computer-details server))
	 (name (assocdr "server_name" (first info)))
	 (ip (assocdr "primary_ip" (first info))))
    (concat ip " -> " name)))

(defun coremacs-ticket-account (ticket)
  "Returns the account associated with TICKET."
  (number-to-string (cdr (fourth (coremacs-ticket-info ticket)))))

(defun coremacs-ticket-servers (ticket)
  "Returns a list of servers associated with TICKET."
  (cdr (first (coremacs-ticket-info ticket))))

(defun coremacs-ticket-status (ticket)
  "Like coremacs-tickets-status, but for a single TICKET.

Returns a string of the ticket status."
  (let ((status (coremacs-tickets-status (list ticket))))
    (cdr (car (car status)))))

(defun coremacs-computer-os-group (server)
  "Returns the OS group of SERVER."
  (assocdr "os_group" (first (coremacs-computer-details server))))

(defun coremacs-private-p (ticket-string)
  "Determines if comment is private based on signature.
Returns 1 if comment is private, 0 if comment is public."
  (if (string-match coremacs-public-signature ticket-string)
      0
    1))

(defun coremacs-update-ticket ()
  "Post contents of current ticket buffer to ticket in CORE."
  (interactive)
  (save-buffer)
  (if (equal mode-name "Ticket")
      (if (buffer-writable-p (current-buffer))
	  (let* ((ticket-string (file->string (buffer-file-name)))
		 (private (coremacs-private-p ticket-string))
		 (ticket (coremacs-ticket-current)))
	    (if (equal (coremacs-ticket-add-message ticket ticket-string private)
		       "success")
		(progn
		  (setq buffer-read-only t)
		  (shell-command (concat "chmod -w " (buffer-file-name)))
		  (coremacs-ticket-history)
		  (message (concat "Comment successfully posted to ticket " ticket)))
	      (error (concat "Posting comment to ticket " ticket " failed"))))
	(error "This ticket has already been posted"))
    (error "You aren't in a ticket buffer")))

(defun coremacs-write-new-public (name)
  (interactive (list (coremacs-ticket-name-read)))
  (switch-to-buffer "*New Ticket*")
  (setq buffer-auto-save-file-name "~/.autosave/#new-ticket#")
  (if (equal name "")
      (insert coremacs-public-greeting-noname ",\n\n")
    (insert (concat coremacs-public-greeting " " name ",\n\n")))
  (save-excursion
    (insert coremacs-public-signature))
  (ticket-mode))

(defun coremacs-write-new-private ()
  (interactive)
  (switch-to-buffer "*New Ticket*")
  (setq buffer-auto-save-file-name "~/.autosave/#new-ticket#")
  (save-excursion
    (insert coremacs-private-signature))
  (ticket-mode))

(defun coremacs-new-ticket (account subject)
  (interactive (list (coremacs-ticket-account-read) (coremacs-ticket-subject-read)))
  (let ((tmp-file (concat "/tmp/cm" (number-to-string (random 100000)))))
    (write-file tmp-file)
    (let* ((ticket-string (file->string tmp-file))
	   (private? (coremacs-private-p ticket-string))
	   (ticket-number (coremacs-ticket-create account subject ticket-string private?)))
      (write-file (concat coremacs-ticket-path ticket-number "-1"))
      (delete-file tmp-file)
      (shell-command (concat "chmod -w " (buffer-file-name)))
      (revert-buffer nil t)
      (coremacs-ticket-history)
      (browse-url (concat coremacs-ticket-url-prefix ticket-number)))))

(defun coremacs-new-subticket (ticket subject)
  (interactive (list (coremacs-ticket-number-read) (coremacs-ticket-subject-read)))
  (let ((tmp-file (concat "/tmp/cm" (number-to-string (random 100000)))))
    (write-file tmp-file)
    (let* ((ticket-string (file->string tmp-file))
	   (private? (coremacs-private-p ticket-string))
	   (ticket-number (coremacs-subticket-create ticket subject ticket-string private?)))
      (write-file (concat coremacs-ticket-path ticket-number "-1"))
      (delete-file tmp-file)
      (shell-command (concat "chmod -w " (buffer-file-name)))
      (revert-buffer nil t)
      (coremacs-ticket-history)
      (browse-url (concat coremacs-ticket-url-prefix ticket-number)))))

(defun coremacs-ticket-post ()
  "Post contents of current ticket buffer to ticket in CORE."
  (interactive)
  (cond ((equal (buffer-name) "*New Ticket*")
	 (call-interactively 'coremacs-new-ticket))
	((equal (buffer-name) "*New Subticket*")
	 (call-interactively 'coremacs-new-subticket))
	(t
	 (coremacs-update-ticket))))

(defun coremacs-computer-ip (server)
  "Returns IP of SERVER."
  (let ((info (coremacs-computer-details server)))
    (assocdr "primary_ip" (first info))))


;;;; Functions for viewing information in browser

;;; Functions to view information in browser about current ticket

(defun coremacs-browse-current-ticket ()
  "In a ticket buffer, open current ticket in web browser."
  (interactive)
  (let ((ticket (coremacs-ticket-current)))
    (if (coremacs-ticket-valid-p ticket)
	(browse-url (concat coremacs-ticket-url-prefix ticket))
      (error "You're not in a valid ticket buffer."))))

(defun coremacs-browse-history ()
  "In a ticket buffer, open the account's ticket history in web browser."
  (interactive)
  (browse-url
   (concat coremacs-ticket-history-prefix
	   (coremacs-ticket-account (coremacs-ticket-current)))))

(defun coremacs-browse-account (&optional account)
  "In a ticket buffer, open the account page for ticket."
  (interactive)
  (browse-url (concat coremacs-account-prefix (if account
						  account
						(coremacs-ticket-account
						 (coremacs-ticket-current))))))

(defmacro coremacs-do-ticket-servers (var &rest body)
  "Loop over the "
  `(let ((servers (coremacs-ticket-servers (coremacs-ticket-current))))
     (unless servers
       (error "Ticket has no servers associated with it"))
     (dolist (,var servers)
       (let ((,var (number-to-string ,var)))
	 ,@body))))

(defun coremacs-browse-servers ()
  "In a ticket buffer, open the server pages for ticket."
  (interactive)
  (coremacs-do-ticket-servers
   server
   (browse-url (concat coremacs-server-prefix server))))

(defun coremacs-browse-servers-pass ()
  "In a ticket buffer, open the server password pages for ticket."
  (interactive)
  (coremacs-do-ticket-servers
   server
   (browse-url (concat coremacs-server-pass-prefix server))))

(defun coremacs-browse-rackwatches ()
  "In a ticket buffer, open Rackwatch histories for each server."
  (interactive)
  (coremacs-do-ticket-servers
   server
   (browse-url (concat coremacs-rackwatch-prefix server))))

(defun coremacs-browse-rackwatch-configs ()
  "In a ticket buffer, open Rackwatch histories for each server."
  (interactive)
  (coremacs-do-ticket-servers
   server
   (browse-url (concat coremacs-rackwatch-config-prefix server))))

(defun coremacs-browse-plesk ()
  "In a ticket buffer, open plesk login screen for servers associated with ticket."
  (interactive)
  (coremacs-do-ticket-servers
   server
   (browse-url (concat "https://" (coremacs-computer-ip server)
		       ":8443/login.php3?previous_page=index"))))

(defun coremacs-browse-ip ()
  (interactive)
  (coremacs-do-ticket-servers
   server
   (browse-url (concat "http://" (coremacs-computer-ip server)))))

(defun coremacs-browse-dnstool ()
  (interactive)
  (coremacs-do-ticket-servers
   server
   (browse-url (concat coremacs-dnstool-prefix "&account_number="
		       (coremacs-ticket-account (coremacs-ticket-current))))))

;;; Functions to view information in browser based on info prompted for

(defun coremacs-goto-plesk (server)
  "Open plesk login screen for SERVER."
  (interactive "nServer number: ")
  (browse-url (concat "https://" (coremacs-computer-ip server)
		      ":8443/login.php3?previous_page=index")))


;;;; Functions for launching external programs

;;; Functions for launching external programs based on info associated with current ticket

(defun coremacs-launch-ticket-shells ()
  "In a ticket buffer, open shells for servers associated with ticket."
  (interactive)
  (let ((non-lin 0))
    (coremacs-do-ticket-servers
     server
     (let ((os (coremacs-computer-os-group server)))
       (if (or (equal os "Linux") (equal os "BSD"))
	   (shell-command (concat coremacs-terminal " -title \"server " server ", ticket "
				  (coremacs-ticket-current) "\" -e " coremacs-autologin
				  " " server "&")
			  (concat "*" server " term*"))
	 (incf non-lin))
       (when (= non-lin (length servers))
	 (error "Ticket has no Linux or BSD servers associated with it"))))))

(defadvice coremacs-launch-ticket-shells (after kill-async-window activate)
  (delete-other-windows))

;;; Functions for launching external programs based in info prompted for

(defun coremacs-open-server-shell (server)
  "Interactive function to open shell for SERVER."
  (interactive "nServer number: ")
  (let ((server (number-to-string server)))
    (shell-command (concat coremacs-terminal " -title \"server " server "\" -e "
			   coremacs-autologin " " server "&")
		   (concat "*" server " term*"))))

(defun coremacs-open-ticket-shells (ticket)
  "Interactive function to open shells for servers associated with TICKET."
  (interactive (list (coremacs-ticket-number-read)))
  (let ((servers (coremacs-ticket-servers ticket))
	(non-lin 0))
    (unless servers
      (error "Ticket has no servers associated with it"))
    (dolist (server servers)
      (let ((server (number-to-string server))
	    (os (coremacs-computer-os-group server)))
	(if (or (equal os "Linux") (equal os "BSD"))
	    (shell-command (concat coremacs-terminal " -title \"server " server ", ticket "
				   ticket "\" -e ~/bin/alng " server "&")
			   (concat "*" server " term*"))
	  (incf non-lin))
	(when (= non-lin (length servers))
	  (error "Ticket has no Linux or BSD servers associated with it"))))))

(defadvice coremacs-open-ticket-shells (after kill-async-window activate)
  (delete-other-windows))

;;;; Functions for manipulating buffers

(defun coremacs-buffers-next (&optional writable)
  "Cycle through ticket buffers starting with the current year."
  (if (ticket-mode-p (current-buffer))
      (bury-buffer))
  (let ((buffers (mapcar (function buffer-name) (buffer-list)))
	(matching 0))
    (catch 'break
      (dolist (buffer buffers)
	(cond (writable
	       (when (and (ticket-mode-p buffer)
			  (buffer-writable-p buffer))
		 (incf matching)
		 (switch-to-buffer buffer)
		 (throw 'break nil)))
	      ((not writable)
	       (when (ticket-mode-p buffer)
		 (incf matching)
		 (switch-to-buffer buffer)
		 (throw 'break nil)))))
      (when (= matching 0)
	  (error "No buffers matched")))))

(defun coremacs-buffers-tickets ()
  "Returns a list of all ticket buffers open."
  (let ((buffers (mapcar (function buffer-name) (buffer-list-saved))))
    (remove-if-not '(lambda (x) (string-match coremacs-ticket-regexp x)) buffers)))

(defun coremacs-buffers-clean-up ()
  "Clean up ticket buffers.  Kill ticket buffers for all but the
5 most recently submitted tickets."
  (interactive)
  (let ((tickets (coremacs-buffers-tickets))
	ticket-times
	(killed 0))
    (dolist (ticket tickets ticket-times)
      (with-current-buffer ticket
	(let ((mtime (time-to-seconds
		      (nth 5 (file-attributes (concat coremacs-ticket-path ticket))))))
	  (push (cons ticket mtime) ticket-times))))
    (let* ((ticket-times (sort ticket-times (lambda (a b) (> (cdr a) (cdr b)))))
	   (i 0))
      (print ticket-times)
      (dotimes (n (length ticket-times))
	(when (>= i 5)
	  (let ((old-ticket (car (nth n ticket-times))))
	    (kill-buffer old-ticket)
	    (incf killed)))
	(incf i)))
    (message (concat "Killed " (number-to-string killed) " old ticket buffers."))))



;;;; Ticket functions

(defconst coremacs-ticket-name-regexp (concat "^" coremacs-ticket-regexp "$")
  "Matches the full ticket name string for determining if ticket name is valid.")

;;; Utility functions for tickets

(defun coremacs-ticket-valid-p (ticket)
  "Determines if ticket name is valid."
  (if (string-match coremacs-ticket-name-regexp ticket) t nil))

(defun coremacs-ticket-current ()
  "When in a ticket buffer, returns the ticket number of the
current buffer."
  (let ((ticket (replace-regexp-in-string "-[0-9]+$" "" (buffer-name))))
    (if (coremacs-ticket-valid-p ticket)
	ticket
      (error "Invalid ticket buffer name"))))


;;; Misc interactive functions for tickets

(defun coremacs-grep (string)
  "Search all tickets for instances of STRING."
  (interactive "sSearch regexp: ")
  (grep-compute-defaults)
  (lgrep string "*[0-9]" coremacs-ticket-path))

(defun coremacs-ticket-history ()
  (interactive)
  (dired coremacs-ticket-path "-BAltr")
  (goto-char (1- (point-max))))

;;; Utility functions and macros for ticket templates

(defun coremacs-ticket-files ()
  "Returns a list of ticket files in directory specified by
coremacs-ticket-path."
  (directory-files coremacs-ticket-path nil (concat "^" coremacs-ticket-regexp "-[0-9]$")))

(defun coremacs-ticket-new-name ()
  "Used in coremacs-ticket-open-new to create the file name for a new
ticket."
  (if coremacs-ticket-path
      (concat coremacs-ticket-path ticket "-" (number-to-string n))
    (error "Variable coremacs-ticket-path not set, see installation instructions")))

(defun coremacs-ticket-open-new ()
  "Prompt for a ticket number and open a new buffer for a file in
coremacs-ticket-path."
  (let ((n 1))
    (while (file-exists-p (coremacs-ticket-new-name))
      (incf n))
    (find-file (coremacs-ticket-new-name))))

(defvar coremacs-ticket-prompt-prefill nil
  "Predict and prefill ticket prompt.  Example: (format-time-string \"%y%m%d-0\")")

(defun coremacs-ticket-number-read ()
  "Prompt user for ticket number."
  (read-from-minibuffer "Ticket number: " coremacs-ticket-prompt-prefill
			nil nil 'coremacs-ticket-number-history))

(defun coremacs-ticket-name-read ()
  "Prompt user for customer name."
  (read-from-minibuffer "Customer's name (RET if unknown): " nil
			nil nil 'coremacs-ticket-name-history))

(defun coremacs-ticket-account-read ()
  "Prompt user for account number."
  (read-from-minibuffer "Account number: " nil
			nil nil 'coremacs-ticket-account-history))

(defun coremacs-ticket-subject-read ()
  "Prompt user for ticket subject."
  (read-from-minibuffer "Ticket subject: " nil
			nil nil 'coremacs-ticket-subject-history))

(defmacro coremacs-public (&rest body)
  "Prompts for a ticket number TICKET and customer name NAME and
creates a buffer for a public ticket."
  `(progn
     (unless (coremacs-ticket-valid-p ticket)
       (error "That's not a valid ticket number."))
     (coremacs-ticket-open-new)
     (if (equal name "")
	 (insert coremacs-public-greeting-noname ",\n\n")
       (insert (concat coremacs-public-greeting " " name ",\n\n")))
     (save-excursion
       ,@body
       (insert coremacs-public-signature))))

(defmacro coremacs-private (&rest body)
  "Prompts for a ticket number TICKET and creates a buffer for a
private ticket."
  `(progn
     (unless (coremacs-ticket-valid-p ticket)
       (error "That's not a valid ticket number."))
     (coremacs-ticket-open-new)
     (save-excursion
       ,@body
       (insert coremacs-private-signature))))

(defun coremacs-password-reset ()
  "Removes cached password."
  (interactive)
  (password-cache-remove "coremacs-pass"))

;;; Default ticket templates

(defun coremacs-public-blank (ticket name)
  "Public ticket with only header and footer."
  (interactive (list (coremacs-ticket-number-read) (coremacs-ticket-name-read)))
  (coremacs-public))

(defun coremacs-private-blank (ticket)
  "Private ticket with only header and footer."
  (interactive (list (coremacs-ticket-number-read)))
  (coremacs-private))

;;; Pre-defined ticket templates

(defun coremacs-public-rackwatch (ticket)
  (interactive (list (coremacs-ticket-number-read)))
  (let ((name ""))
    (coremacs-public
     (insert "Your Rackspace configuration includes the Rackwatch Platinum monitoring solution.  As with the Rackwatch Basic service, if ping fails, we will restart your server.

Our Platinum Service also allows you to choose up to 6 additional ports to have monitored.  If any of these ports should fail to respond, our monitoring service will alert us to the problem and our experienced technicians will automatically fix the problem according to our support policy.  You will then receive notification via a support ticket.


You also have the option to setup RackWatch-related contact names and emails. These RackWatch Contacts are identified as recipients for any Rackwatch-related ticket notifications.


Below are the services that are available for monitoring at this time:



HTTP
HTTPS
DNS
MySQL
PostgreSQL
MS SQL
SMTP
POP3
IMAP
FTP
SSH
Cold Fusion


For the initial configuration, we have verified that the following services are currently running on your server and have been proactively configured to be monitored at this time.


SSH


This is only the initial configuration and can be modified at any time with no additional charge. You may contact us at any time if you would like to disable or enable monitoring for a particular service. However, we will only be able to monitor a service if it is running on its standard port and on the primary IP address. If monitoring is enabled for a service that is not running on the primary IP, a false alert will be generated and we will need to disable monitoring until we can receive a proper response from the server.

If you would like your Rackwatch monitoring configuration to remain as it is for now, no further action is required of you at this time.

Please let me know if you need any other assistance."))))

(defun coremacs-public-ip (ticket)
  (interactive (list (coremacs-ticket-number-read)))
  (let ((name ""))
    (coremacs-public
     (insert "As requested, the following IP has been added and configured on your server:



Please let me know if you need any other assistance."))))


(defun coremacs-private-ptr (ticket)
  "Private ticket requesting NetSec to configure PTR record."
  (interactive (list (coremacs-ticket-number-read)))
  (coremacs-private
   (insert "NetSec,

Please setup the following PTR record:

" (coremacs-computer-ptr (first (coremacs-ticket-servers ticket))))))


;;; Prefab functions

(defun coremacs-prefab (prefab)
  (save-excursion
    (insert-string prefab)))

(defun coremacs-prefab-rootpassword ()
  (interactive)
  (coremacs-prefab "Direct root logins are disabled by default for higher security.  In order to login to your server as root, you'll have to SSH as an unprivileged user, then type \"su -\" and the root password to login as root.

The root password is:"))

;;;; Miscellaneous

;; (defun coremacs-info (&optional node)
;;   "Read documentation for Coremacs in the info system.
;; With optional NODE, go directly to that node."
;;   (interactive)
;;   (info (format "(%s)%s" coremacs-info-file (or node ""))))

(defun coremacs-print-abbrevs (t)
  "Pretty-print a list of all abbrevs in list T."
  (dolist (a t)
    (princ (format "%s = %s\n" (first a) (truncate-string-to-width (second a) 60)))))

(defun coremacs-create-ticket-account-table ()
  (interactive)
  (find-file (concat coremacs-ticket-path ".ticket-account-table"))
  (insert "(setq coremacs-ticket-account-table (make-hash-table :test 'equal))\n")
  (let* ((files (directory-files "~/tickets" nil "^[0-9].*[0-9]$"))
	 (tickets (remove-duplicates
		   (mapcar '(lambda (x) (truncate-string-to-width x 12)) files)
		   :test 'equalp))
	 (cur 0)
	 (end (length tickets)))
    (dolist (ticket tickets)
      (let ((account (coremacs-ticket-account ticket)))
	(insert (format "(puthash \"%s\" \"%s\" coremacs-ticket-account-table)\n"
			ticket account)))
      (save-buffer)
      (message (format "At record %s out of %s" cur end))
      (sleep-for 4))))

(defun coremacs-load-ticket-account-table ()
  (interactive)
  (load-file (concat coremacs-ticket-path ".ticket-account-table")))

(defun coremacs-insert-screen-exchange (server)
  (interactive "nServer number: ")
  (message "Downloading screen-exchange file from server...")
  (shell-command (concat "get-server-screen-buffer " (number-to-string server)))
  (insert-file "/tmp/screen-exchange"))

(provide 'coremacs)
;;; coremacs.el ends here
