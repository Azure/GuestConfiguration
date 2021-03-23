Describe 'Test Environment' {
    Context 'Simple' {
        It 'PSModulePath is not null or empty' {
            $Env:PSModulePath | Should -Not -BeNullOrEmpty
        }
    }
}
