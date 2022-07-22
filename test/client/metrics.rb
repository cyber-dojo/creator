
# max values used by cyberdojo/check-test-results image
# which is called from sh/test_in_containers.sh

MAX = {
  failures:0,
  errors:0,
  warnings:2,
  skips:0,

  duration:120,

  app: {
    lines: {
       total:164,
      missed:20,
    },
    branches: {
       total:16,
      missed:8,
    }
  },

  test: {
    lines: {
       total:95,
      missed:0,
    },
    branches: {
       total:0,
      missed:0,
    }
  }
}
