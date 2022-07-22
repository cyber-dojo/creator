
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
       total:430,
      missed:3,
    },
    branches: {
       total:38,
      missed:8,
    }
  },

  test: {
    lines: {
       total:381,
      missed:0,
    },
    branches: {
       total:2,
      missed:1,
    }
  }
}
