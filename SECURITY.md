# Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| 0.x     | :white_check_mark: |

## Reporting a Vulnerability

**Do not open a public issue for security vulnerabilities.**

Instead, please use [GitHub Security Advisories](https://github.com/stigvaage/komponentbibliotek-flutter/security/advisories/new) to report vulnerabilities privately.

### What to include

- A description of the vulnerability
- Steps to reproduce or a proof of concept
- The impact you have identified
- Any suggested fix (optional)

### Response timeline

- **48 hours**: Acknowledgment of your report
- **7 days**: Initial assessment and severity classification
- **30 days**: Target for a fix or mitigation to be released

We will keep you informed throughout the process and credit you in the advisory (unless you prefer to remain anonymous).

## Security Guidelines for Contributors

- **No secrets in code**: Never commit API keys, tokens, passwords, or other credentials. Use environment variables or GitHub Secrets for CI/CD.
- **Least privilege CI**: Workflows should request only the permissions they need.
- **Keep dependencies updated**: Use Dependabot alerts and keep dependencies current.
- **Review third-party code**: Evaluate new dependencies for known vulnerabilities before adding them.
