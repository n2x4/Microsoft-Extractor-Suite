OAuth Permissions
=======
OAuth is a way of authorizing third-party applications to login into user accounts such as social media and webmail. The advantage of OAuth is that users don’t have to reveal their password; instead, the third-party applications use a token for authentication. In an OAuth abuse attack, a victim authorizes a third-party application to access their account. Once authorized, the application accesses the user’s data without the need for credentials. The user receives a message to accept the application with its requested API permissions. After the user selects accept, the threat actor has control of the user’s account.

.. note::

   Script made by psignoret: https://gist.github.com/psignoret/41793f8c6211d2df5051d77ca3728c09

Usage
""""""""""""""""""""""""""
List delegated permissions (OAuth2PermissionGrants) and application permissions (AppRoleAssignments):
::

   Get-OAuthPermissions

Output
""""""""""""""""""""""""""
The output will be saved to the 'OAuthPermissions' directory within the 'Output' directory, with the file name 'OAuthPermissions.csv'.
