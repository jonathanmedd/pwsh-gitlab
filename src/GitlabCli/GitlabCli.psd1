@{
    ModuleVersion = '1.66.0'

    PrivateData = @{
        PSData = @{
            LicenseUri = 'https://github.com/chris-peterson/pwsh-gitlab/blob/main/LICENSE'
            ProjectUri = 'https://github.com/chris-peterson/pwsh-gitlab'
            ReleaseNotes = 'Get pipeline variables'
        }
    }

    GUID = '220fdbee-bea7-4951-9375-f6e76bd981b4'

    Author = 'Chris Peterson'
    CompanyName = 'Chris Peterson'
    Copyright = '(c) 2021-2022'

    Description = 'Interact with GitLab via PowerShell'
    PowerShellVersion = '7.1'

    ScriptsToProcess = @('_Init.ps1')
    TypesToProcess = @('Types.ps1xml')
    FormatsToProcess = @('Formats.ps1xml')

    NestedModules = @(
        'Branches.psm1'
        'Config.psm1'
        'Deployments.psm1'
        'Environments.psm1'
        'Git.psm1'
        'GraphQL.psm1'
        'GroupAccessTokens.psm1'
        'Groups.psm1'
        'Issues.psm1'
        'Jobs.psm1'
        'Members.psm1'
        'MergeRequests.psm1'
        'Notes.psm1'
        'Pipelines.psm1'
        'Projects.psm1'
        'RepositoryFiles.psm1'
        'Runners.psm1'
        'Search.psm1'
        'Users.psm1'
        'Utilities.psm1'
        'Variables.psm1'
    )
    FunctionsToExport = @(
        # Git
        'Get-LocalGitContext'

        # Branches
        'Get-GitlabBranch'
        'Get-GitlabProtectedBranch'
        'New-GitlabBranch'
        'Protect-GitlabBranch'
        'UnProtect-GitlabBranch'
        'Remove-GitlabBranch'
        'Get-GitlabProtectedBranchAccessLevel'

        # Configuration
        'Get-GitlabConfiguration'
        'Add-GitlabSite'
        'Remove-GitlabSite'
        'Get-DefaultGitlabSite'
        'Set-DefaultGitlabSite'

        # GraphQL
        'Invoke-GitlabGraphQL'

        # Group Access Tokens
        'Get-GitlabGroupAccessToken'
        'New-GitlabGroupAccessToken'
        'Remove-GitlabGroupAccessToken'

        # Groups
        'Get-GitlabGroup'
        'New-GitlabGroup'
        'Remove-GitlabGroup'
        'Rename-GitlabGroup'
        'Copy-GitlabGroupToLocalFileSystem'
        'Update-GitlabGroup'
        'Update-LocalGitlabGroup'
        'Get-GitlabGroupVariable'
        'Set-GitlabGroupVariable'
        'Remove-GitlabGroupVariable'
        'New-GitlabGroupShareLink'
        'Remove-GitlabGroupShareLink'

        # Projects
        'Get-GitlabProject'
        'ConvertTo-GitlabTriggerYaml'
        'New-GitlabProject'
        'Update-GitlabProject'
        'Move-GitlabProject'
        'Rename-GitlabProject'
        'Rename-GitlabProjectDefaultBranch'
        'Copy-GitlabProject'
        'Invoke-GitlabProjectArchival'
        'Invoke-GitlabProjectUnarchival'
        'Get-GitlabProjectVariable'
        'Set-GitlabProjectVariable'
        'Remove-GitlabProjectVariable'

        # Repository Files
        'Get-GitlabRepositoryFile'
        'Get-GitlabRepositoryTree'
        'Get-GitlabRepositoryFileContent'
        'Get-GitlabRepositoryYmlFileContent'
        'New-GitlabRepositoryFile'
        'Update-GitlabRepositoryFile'

        # Environments
        'Get-GitlabEnvironment'
        'Stop-GitlabEnvironment'
        'Remove-GitlabEnvironment'

        # Deployments
        'Get-GitlabDeployment'

        # Issues
        'Get-GitlabIssue'
        'New-GitlabIssue'
        'Update-GitlabIssue'
        'Open-GitlabIssue'
        'Close-GitlabIssue'

        # Notes
        'Get-GitlabIssueNote'
        'New-GitlabIssueNote'
        'Get-GitlabMergeRequestNote'

        # MergeRequests
        'Get-GitlabMergeRequest'
        'New-GitlabMergeRequest'
        'Merge-GitlabMergeRequest'
        'Set-GitlabMergeRequest'
        'Invoke-GitlabMergeRequestReview'
        'Approve-GitlabMergeRequest'
        'Update-GitlabMergeRequest'
        'Close-GitlabMergeRequest'

        # Pipelines
        'Get-GitlabPipeline'
        'Get-GitlabPipelineVariable'
        'New-GitlabPipeline'
        'Remove-GitlabPipeline'
        'Get-GitlabPipelineSchedule'
        'New-GitlabPipelineSchedule'
        'Update-GitlabPipelineSchedule'
        'Remove-GitlabPipelineSchedule'
        'New-GitlabScheduledPipeline'
        'Get-GitlabPipelineBridge'

        # Jobs
        'Get-GitlabJob'
        'Get-GitlabJobTrace'
        'Start-GitlabJob'
        'Get-GitlabPipelineDefinition'
        'Test-GitlabPipelineDefinition'

        # Runners
        'Get-GitlabRunner'
        'Get-GitlabRunnerJobs'
        'Update-GitlabRunner'
        'Suspend-GitlabRunner'
        'Resume-GitlabRunner'

        # Search
        'Search-Gitlab'
        'Search-GitlabProject'

        # User
        'Get-GitlabUser'
        'Get-GitlabCurrentUser'

        # Events
        'Get-GitlabUserEvent'
        'Get-GitlabProjectEvent'

        # Members
        'Get-GitlabGroupMember'
        'Add-GitlabGroupMember'
        'Remove-GitlabGroupMember'

        'Get-GitlabProjectMember'
        'Add-GitlabProjectMember'
        'Remove-GitlabProjectMember'

        'Get-GitlabUserMembership'
        'Add-GitlabUserMembership'
        'Update-GitlabUserMembership'
        'Get-GitlabMemberAccessLevel'

        # Utilities
        'ConvertTo-PascalCase'
        'ConvertTo-SnakeCase'
        'ConvertTo-UrlEncoded'
        'Get-FilteredObject'
        'Get-GitlabVersion'
        'Invoke-GitlabApi'
        'New-WrapperObject'
        'Open-InBrowser'
        'ValidateGitlabDateFormat'

        # Variables
        'Resolve-GitlabVariable'
    )
    AliasesToExport = @(
        # long form
        'Clone-GitlabGroup'
        'Pull-GitlabGroup'
        'Transfer-GitlabProject'
        'Fork-GitlabProject'
        'Archive-GitlabProject'
        'Unarchive-GitlabProject'
        'Review-GitlabMergeRequest'
        'Play-GitlabJob'
        'Revoke-GitlabGroupAccessToken'

        # short form
        'go'
        'build'
        'envs'
        'deploys'
        'pipeline'
        'pipelines'
        'schedule'
        'schedules'
        'job'
        'jobs'
        'trace'
        'issue'
        'issues'
        'mr'
        'mrs'
        'var'
    )
}
