# GitHub Action for exporting JSONResume

This action exports your resume in [JSONResume](https://jsonresume.org/) to **HTML** or **PDF**.

This can be combined with other actions to publish your resume as a Github page.

> Example: https://kelvintaywl.github.io/resume

## Inputs

| Name            | Description                                               | Default       |
| ---             | ---                                                       | ---           |
| theme           | JSONResume theme name. See https://jsonresume.org/themes/ | `flat`        |
| resume_filepath | file path to your resume in JSONResume format             | `resume.json` |
| resume_format   | output file format - pdf or html                          | `pdf`         |
| output_filepath | output file path                                          | `index.pdf`   |

## Example Workflows

### To publish your resume as a Github page

> This example assumes you have a resume.json at the **root directory of your repository**. 

> In addition, this assumes you have set up your GitHub pages on this repository [to reference the `docs/` folder as your source](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#choosing-a-publishing-source).

```yaml
# example GitHub workflow

name: Publish resume in JSONResume format as Github Page
 
on:
  push:
    branches: [ master ]

jobs:
  check_run:
    runs-on: ubuntu-latest
    if: "! contains(github.event.head_commit.message, '[ci skip]')"
    steps:
      - run: echo "${{ github.event.head_commit.message }}"

  build:
    runs-on: ubuntu-latest
    needs: check_run
    steps:
      - uses: actions/checkout@v2
      - uses: AlexDumanskiy/action-jsonresume-export@v1
        name: Export resume as HTML
        with:
          theme: macchiato
          resume_filepath: resume.json
          output_format: html
          # modifies the index.html in-place
          output_filepath: docs/index.html
      - name: Commit published HTML
        id: commit
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          if [ -n "$(git status --porcelain docs/index.html)" ]; then
            git add docs/index.html
            git commit -m "[ci skip] chore(docs/index.html): update resume page"
            echo ::set-output name=exit_code::0
          else
            echo ::set-output name=exit_code::1
          fi
      - name: Push changes
        uses: ad-m/github-push-action@master
        if: steps.commit.outputs.exit_code == 0
        with:
          github_token: ${{ secrets.GH_TOKEN }}
          branch: ${{ github.ref }}
```


## Thanks
This repo is a fork of https://github.com/kelvintaywl/action-jsonresume-export modified to generate PDF files as well as HTML.

