
# max values used by cyberdojo/check-test-results image
# which is called from sh/test_in_containers.sh

# Typical duration on local laptop is <20s
# but can be double that on CI

MAX = {
  failures:0,
  errors:0,
  warnings:0,
  skips:0,

  duration:40,

  app: {
    lines: {
       total:422,
      missed:3,
    },
    branches: {
       total:28,
      missed:3,
    }
  },

  test: {
    lines: {
       total:353,
      missed:0,
    },
    branches: {
       total:0,
      missed:0,
    }
  }
}
