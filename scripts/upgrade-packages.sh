#!/bin/bash

# NuGet Package Upgrade Script
# This script automates the process of checking for and applying NuGet package upgrades
# Usage: ./scripts/upgrade-packages.sh [--apply] [--security-only]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default options
APPLY_UPDATES=false
SECURITY_ONLY=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --apply)
            APPLY_UPDATES=true
            shift
            ;;
        --security-only)
            SECURITY_ONLY=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--apply] [--security-only]"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}🔍 Checking for package updates...${NC}"

# Check for outdated packages
echo -e "\n${YELLOW}📦 Checking outdated packages:${NC}"
dotnet list package --outdated --source https://api.nuget.org/v3/index.json

# Check for security vulnerabilities
echo -e "\n${RED}🔒 Checking for security vulnerabilities:${NC}"
VULN_OUTPUT=$(dotnet list package --vulnerable --source https://api.nuget.org/v3/index.json)
echo "$VULN_OUTPUT"

# Check if vulnerabilities exist
if echo "$VULN_OUTPUT" | grep -q "has no vulnerable packages"; then
    echo -e "${GREEN}✅ No security vulnerabilities found!${NC}"
    VULNERABILITIES_FOUND=false
else
    echo -e "${RED}⚠️  Security vulnerabilities detected!${NC}"
    VULNERABILITIES_FOUND=true
fi

if [ "$APPLY_UPDATES" = true ]; then
    echo -e "\n${BLUE}🚀 Applying package updates...${NC}"
    
    if [ "$SECURITY_ONLY" = true ] && [ "$VULNERABILITIES_FOUND" = false ]; then
        echo -e "${GREEN}✅ No security updates needed.${NC}"
        exit 0
    fi
    
    # Build and test before updates
    echo -e "\n${YELLOW}🏗️  Building and testing current state...${NC}"
    dotnet build
    dotnet test
    
    if [ "$SECURITY_ONLY" = false ]; then
        echo -e "\n${YELLOW}📦 Updating all packages...${NC}"
        # Note: This is a manual process as dotnet doesn't have a built-in command to update all packages
        echo -e "${YELLOW}Manual step required: Update package versions in .csproj files based on outdated package report above${NC}"
        echo -e "${YELLOW}After updating, run: dotnet restore && dotnet build && dotnet test${NC}"
    fi
    
    # Verify no vulnerabilities remain
    echo -e "\n${RED}🔒 Final security check...${NC}"
    FINAL_VULN_OUTPUT=$(dotnet list package --vulnerable --source https://api.nuget.org/v3/index.json)
    
    if echo "$FINAL_VULN_OUTPUT" | grep -q "has no vulnerable packages"; then
        echo -e "${GREEN}✅ All security vulnerabilities resolved!${NC}"
    else
        echo -e "${RED}❌ Some security vulnerabilities still remain:${NC}"
        echo "$FINAL_VULN_OUTPUT"
        exit 1
    fi
    
    echo -e "\n${GREEN}✅ Package update process completed!${NC}"
    echo -e "${BLUE}💡 Don't forget to:${NC}"
    echo -e "   - Test the application thoroughly"
    echo -e "   - Update any breaking changes in code"
    echo -e "   - Run the full test suite"
    echo -e "   - Update documentation if needed"
    
else
    echo -e "\n${BLUE}💡 To apply updates, run: $0 --apply${NC}"
    echo -e "${BLUE}💡 For security updates only, run: $0 --apply --security-only${NC}"
    
    if [ "$VULNERABILITIES_FOUND" = true ]; then
        echo -e "\n${RED}⚠️  IMPORTANT: Security vulnerabilities found! Run security updates immediately.${NC}"
        exit 1
    fi
fi

exit 0