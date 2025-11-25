# Contributing to CWL Workshop Materials

Thank you for your interest in improving the CWL for SKA Data Processing workshop!

## Ways to Contribute

### Report Issues
- Found a bug in an exercise? Open an issue!
- Instructions unclear? Let us know!
- Suggestions for new exercises? We'd love to hear them!

### Submit Fixes
1. Fork the repository
2. Create a feature branch (`git checkout -b fix/exercise-typo`)
3. Make your changes
4. Test the exercises locally
5. Submit a pull request

### Improve Documentation
- Fix typos
- Add clarifications
- Improve examples
- Translate materials

## Testing Changes

Before submitting, please verify:

```bash
# Validate all CWL files
for f in exercises/*/*.cwl; do cwltool --validate "$f"; done

# Run Exercise 1
cd exercises/01-hello-cwl
cwltool hello.cwl hello-job.yml
```

## Style Guidelines

### CWL Files
- Use `cwlVersion: v1.2`
- Include `doc` and `label` fields
- Follow consistent indentation (2 spaces)
- Add meaningful comments

### Documentation
- Use clear, simple language
- Include code examples
- Test all commands before documenting

## Questions?

- Open an issue for general questions
- Join the CWL Discourse: https://cwl.discourse.group/
- Contact workshop maintainers

Thank you for contributing! 🎉
