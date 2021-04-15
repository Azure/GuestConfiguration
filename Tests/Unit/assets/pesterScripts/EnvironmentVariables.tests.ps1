describe 'Test Environment' -Tag PesterLanguage {
    context 'Simple' {
        It 'PSModulePath is not null or empty' {
            $Env:PSModulePath | Should -Not -BeNullOrEmpty
        }

        It 'Path is not null or empty' {
            $Env:Path | Should -Not -BeNullOrEmpty
        }
    }
}
