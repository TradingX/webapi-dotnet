using Microsoft.Extensions.DependencyInjection;
using System;
using System.Reflection;
using Xunit;
using Azure.Identity;
using Microsoft.EntityFrameworkCore;

namespace webapi.tests.UpgradeValidation
{
    /// <summary>
    /// Tests to validate that package upgrades were successful and security vulnerabilities are fixed
    /// </summary>
    public class PackageUpgradeTests
    {
        [Fact]
        public void AzureIdentity_Should_Be_UpgradedVersion()
        {
            // Arrange & Act
            var azureIdentityAssembly = typeof(DefaultAzureCredential).Assembly;
            var version = azureIdentityAssembly.GetName().Version;
            
            // Assert - Should be version 1.15.0 or higher (fixing security vulnerabilities)
            Assert.True(version.Major >= 1, $"Azure.Identity major version should be 1 or higher, but was {version}");
            Assert.True(version.Minor >= 15 || version.Major > 1, 
                $"Azure.Identity should be version 1.15.0 or higher to fix security vulnerabilities, but was {version}");
        }
        
        [Fact]
        public void EntityFramework_Should_Be_UpgradedVersion()
        {
            // Arrange & Act
            var efAssembly = typeof(DbContext).Assembly;
            var version = efAssembly.GetName().Version;
            
            // Assert - Should be version 8.0.0 or higher (compatible with .NET 8.0)
            Assert.True(version.Major >= 8, $"Entity Framework major version should be 8 or higher for .NET 8.0, but was {version}");
        }
        
        [Fact]
        public void TargetFramework_Should_Be_NET80()
        {
            // Arrange & Act
            var targetFramework = Assembly.GetExecutingAssembly().GetCustomAttribute<System.Runtime.Versioning.TargetFrameworkAttribute>();
            
            // Assert
            Assert.NotNull(targetFramework);
            Assert.Contains("NETCoreApp,Version=v8.0", targetFramework.FrameworkName, StringComparison.OrdinalIgnoreCase);
        }
        
        [Fact]
        public void DefaultAzureCredential_Should_BeInstantiable()
        {
            // Arrange & Act & Assert - Should not throw exceptions
            var credential = new DefaultAzureCredential();
            Assert.NotNull(credential);
        }
    }
}