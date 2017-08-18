# Mock API endpoint

The mock API server can be used for For integration development, debugging and QA.
This is a simple flask application, and only handles "happy path" of everything working correctly.

## Installation
- `virtualenv ${whatever_youd_like_to_call_your_virtualenv_for_this}`
- `source ${whatever_youd_like_to_call_your_virtualenv_for_this}/bin/activate`
- `cd $DCM_REPO_ROOT/api; pip install -r requirements-mock.txt`

## Running
- `cd $DCM_REPO_ROOT/api` (if necessary)
- `./dev_mock.sh` (for unix based systems)

## Testing
- `export DCM_HOST=localhost:5000`
- Use DCM test scripts in `ansible/roles/dcm/files/root/scripts`


