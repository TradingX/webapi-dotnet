# Package Management and Security Updates

This document outlines the package management strategy and security update processes for the webapi-dotnet project.

## Current Status

✅ **Framework**: .NET 8.0 (LTS)  
✅ **Security**: No known vulnerabilities  
✅ **Packages**: Updated to latest compatible versions  
✅ **Tests**: All passing (14/14)  

## Automated Security Monitoring

### Daily Security Scans
The project includes automated daily security scans via GitHub Actions:
- **Workflow**: `.github/workflows/security-updates.yaml`
- **Schedule**: Daily at 6:00 AM UTC
- **Action**: Creates issues for any detected vulnerabilities

### Manual Security Check
Run the security check script manually:
```bash
./scripts/upgrade-packages.sh
```

For security-only updates:
```bash
./scripts/upgrade-packages.sh --apply --security-only
```

## Package Update Strategy

### 1. Security Updates (Priority: Critical)
- **Frequency**: Immediate upon detection
- **Scope**: Only packages with known security vulnerabilities
- **Testing**: Automated tests must pass before deployment

### 2. Regular Updates (Priority: Medium)
- **Frequency**: Monthly or quarterly
- **Scope**: All outdated packages
- **Considerations**: 
  - Breaking changes evaluation
  - Extended testing period
  - Compatibility verification

### 3. Major Version Updates (Priority: Low)
- **Frequency**: With major release cycles
- **Scope**: Framework and major dependency upgrades
- **Considerations**:
  - Comprehensive testing
  - Code migration for breaking changes
  - Documentation updates

## Package Categories

### Core Framework Packages
- **Microsoft.EntityFrameworkCore**: Currently 8.0.8 (compatible with .NET 8.0)
- **Microsoft.AspNetCore.App**: Implicit with .NET 8.0

### Security & Identity
- **Azure.Identity**: 1.15.0 (updated from 1.3.0 to fix security vulnerabilities)
- **Azure.Extensions.AspNetCore.Configuration.Secrets**: 1.4.0

### API Documentation
- **Swashbuckle.AspNetCore**: 6.8.1 (compatible with .NET 8.0)

### Testing Framework
- **xunit**: 2.9.3
- **AutoFixture**: 4.18.1
- **Microsoft.NET.Test.Sdk**: 17.14.1

## Upgrade Process

### Step 1: Assessment
1. Run security vulnerability check
2. Check for outdated packages
3. Review changelog and breaking changes
4. Assess impact on existing functionality

### Step 2: Planning
1. Prioritize security updates
2. Group compatible updates
3. Plan testing strategy
4. Schedule deployment window

### Step 3: Implementation
1. Update package versions in `.csproj` files
2. Run `dotnet restore`
3. Build the solution: `dotnet build`
4. Execute tests: `dotnet test`
5. Fix any breaking changes
6. Validate functionality

### Step 4: Validation
1. Run full test suite
2. Perform integration testing
3. Security scan verification
4. Performance testing (if applicable)

### Step 5: Deployment
1. Create pull request with changes
2. Code review
3. CI/CD pipeline validation
4. Merge and deploy

## Security Vulnerabilities History

### Resolved Issues
- **Azure.Identity 1.3.0**: Fixed multiple vulnerabilities by upgrading to 1.15.0
  - GHSA-5mfx-4wcx-rv27 (High severity)
  - GHSA-m5vv-6r4h-3vj9 (Moderate severity)
  - GHSA-wvxc-855f-jvrv (Moderate severity)

## Tools and Scripts

### Package Upgrade Script
- **Location**: `scripts/upgrade-packages.sh`
- **Purpose**: Automated package checking and upgrade assistance
- **Usage**: 
  ```bash
  # Check only
  ./scripts/upgrade-packages.sh
  
  # Apply all updates
  ./scripts/upgrade-packages.sh --apply
  
  # Security updates only
  ./scripts/upgrade-packages.sh --apply --security-only
  ```

### Upgrade Validation Tests
- **Location**: `services/webapi/tests/UpgradeValidation/PackageUpgradeTests.cs`
- **Purpose**: Validate that upgrades were successful
- **Coverage**:
  - Framework version validation
  - Security package version validation
  - Package instantiation tests

## Best Practices

### Do's ✅
- Monitor security advisories regularly
- Update security packages immediately
- Test thoroughly after updates
- Document breaking changes
- Keep dependencies up to date
- Use LTS versions for production

### Don'ts ❌
- Don't ignore security vulnerabilities
- Don't update everything at once without testing
- Don't skip version compatibility checks
- Don't deploy without proper testing
- Don't use outdated frameworks in production

## Emergency Security Response

In case of critical security vulnerabilities:

1. **Immediate Assessment** (within 4 hours)
   - Evaluate impact and severity
   - Identify affected packages
   - Check for available fixes

2. **Quick Response** (within 24 hours)
   - Apply security patches
   - Run automated tests
   - Deploy to staging environment

3. **Validation and Deployment** (within 48 hours)
   - Extended testing
   - Production deployment
   - Monitor for issues

## Resources

- [.NET Package Security](https://docs.microsoft.com/en-us/nuget/reference/security)
- [GitHub Security Advisories](https://github.com/advisories)
- [Azure Identity Security Updates](https://github.com/Azure/azure-sdk-for-net/releases)
- [Entity Framework Core Releases](https://github.com/dotnet/efcore/releases)