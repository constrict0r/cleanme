**cleanme-sh**
--------------------------------------------------------------

Bash script to clean enviroments.

Globals
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  **ONLY_TYPE**

      String indicating to clean only resources of specific types.
      The allowed values are: ap, being a = ansible,
      p = python.

  **PROJECT_PATH**

      Path to the project to cleanup, if not specified the current path will
      be used.

  **UNINSTALL**

      Wheter to uninstall or not the following software: ansible, python3.
      Default to *false*.

Functions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   **cleanup_ansible()**

      Delete ansible auto-created files.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **cleanup_general()**

      Delete general auto-created files.

      :Parameters:
         **$1** (*str*) – Optional path to project. Default to current path.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **cleanup_python()**

      Delete python auto-created files.

      :Parameters:
         **$1** (*str*) – Optional path to project. Default to current path.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **error_message()**

      Shows an error message.

      :Parameters:
         **$1** (*str*) – Message to show.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **get_parameters()**

      Get bash parameters.

      Accepts:

       - *h* (help).
       - *o* <types> (only clean type).
       - *p* <path> (project_path).
       - *u* (uninstall).

      :Parameters:
         **$@** (*str*) – Bash arguments.

      :Returns:
         0 if successful, 1 on failure. Set globals.

      :Return type:
        int

   **help()**

      Shows help message.

      :Parameters:
         Function has no arguments.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **main()**

     Setup requirements and run tests.

      :Parameters:
         **$@** (*str*) – Bash arguments.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int

   **sanitize()**

      Sanitize input.

      The applied operations are:

       - Trim.

      :Parameters:
         **$1** (*str*) – Text to sanitize.

      :Returns:
         The sanitized input.

      :Return type:
        str

   **trim()**

      Trim whitespace at the beggining and end of a string.

      :Parameters:
         **$1** (*str*) – Text where to apply trim.

      :Returns:
         The trimmed input.

      :Return type:
         str

   **uninstall_ansible()**

      Uninstall Ansible.

      :Returns:
         0 if successful, 1 on failure.

      :Return type:
        int