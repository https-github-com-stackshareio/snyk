#shellcheck shell=sh

Describe "Snyk iac test command"
  Before snyk_login
  After snyk_logout
  Describe "terraform directory scan"
    It "finds issues in terraform directory"
      When run snyk iac test ../fixtures/iac/terraform/
      The status should be failure # issues found
      The output should include "Testing sg_open_ssh.tf..."

      The output should include "Infrastructure as code issues:"

      The output should include "✗ Security Group allows open ingress [Medium Severity] [SNYK-CC-TF-1] in Security Group"
      The output should include "introduced by resource > aws_security_group[allow_ssh] > ingress"
    

      # File Outputs Summary
      The output should include "Organization:"
      The output should include "Type:              Terraform"
      The output should include "Target file:       sg_open_ssh.tf"
      The output should include "Project name:      terraform"
      The output should include "Open source:       no"
      The output should include "Project path:      ../fixtures/iac/terraform/"

      The output should include "Tested sg_open_ssh.tf for known issues, found"

      # Invalid File testing - Go Template
      The output should include "Testing sg_open_ssh_invalid_go_templates.tf..."
      The output should include "Illegal Terraform target file sg_open_ssh_invalid_go_templates.tf "
      The output should include "Validation Error Reason: Go Template placeholders found in Terraform file."
      The output should include "Please see our documentation for supported target files (currently we support Kubernetes files only): https://support.snyk.io/hc/en-us/articles/360006368877-Scan-and-fix-security-issues-in-your-Kubernetes-configuration-files and make sure you are in the right directory."

      # Invalid File testing - HCL2 Format
      The output should include "Testing sg_open_ssh_invalid_hcl2.tf..."
      The output should include "Illegal Terraform target file sg_open_ssh_invalid_hcl2.tf"
      The output should include "Validation Error Reason: Invalid HCL2 Format."
      The output should include "Please see our documentation for supported target files (currently we support Kubernetes files only): https://support.snyk.io/hc/en-us/articles/360006368877-Scan-and-fix-security-issues-in-your-Kubernetes-configuration-files and make sure you are in the right directory."
    End

    It "filters out issues when using severity threshold"
      When run snyk iac test ../fixtures/iac/terraform --severity-threshold=high
      The status should be success # no issues found
      The output should include "Testing sg_open_ssh.tf..."

      The output should include "Infrastructure as code issues:"

      # File Outputs Summary
      The output should include "Organization:"
      The output should include "Type:              Terraform"
      The output should include "Target file:       sg_open_ssh.tf"
      The output should include "Project name:      terraform"
      The output should include "Open source:       no"
      The output should include "Project path:      ../fixtures/iac/terraform"

      The output should include "Tested sg_open_ssh.tf for known issues, found"

      # Invalid File testing - Go Template
      The output should include "Testing sg_open_ssh_invalid_go_templates.tf..."
      The output should include "Illegal Terraform target file sg_open_ssh_invalid_go_templates.tf "
      The output should include "Validation Error Reason: Go Template placeholders found in Terraform file."
      The output should include "Please see our documentation for supported target files (currently we support Kubernetes files only): https://support.snyk.io/hc/en-us/articles/360006368877-Scan-and-fix-security-issues-in-your-Kubernetes-configuration-files and make sure you are in the right directory."

      # Invalid File testing - HCL2 Format
      The output should include "Testing sg_open_ssh_invalid_hcl2.tf..."
      The output should include "Illegal Terraform target file sg_open_ssh_invalid_hcl2.tf"
      The output should include "Validation Error Reason: Invalid HCL2 Format."
      The output should include "Please see our documentation for supported target files (currently we support Kubernetes files only): https://support.snyk.io/hc/en-us/articles/360006368877-Scan-and-fix-security-issues-in-your-Kubernetes-configuration-files and make sure you are in the right directory."
    End

    It "outputs the expected text when running with --sarif flag"
      When run snyk iac test ../fixtures/iac/terraform/ --sarif
      The status should be failure
      The output should include '"id": "SNYK-CC-TF-1",'
      The output should include '"ruleId": "SNYK-CC-TF-1",'
    End

    It "outputs the expected text when running with --json flag"
      When run snyk iac test ../fixtures/iac/terraform/ --json
      The status should be failure
      The output should include '"id": "SNYK-CC-TF-1",'
      The output should include '"packageManager": "terraformconfig",'
      The result of function check_valid_json should be success
    End
  End
End
