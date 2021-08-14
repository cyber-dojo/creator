
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
       total:128,
      missed:1,
    },
    branches: {
       total:6,
      missed:1,
    }
  },

  test: {
    lines: {
       total:112,
      missed:0,
    },
    branches: {
       total:0,
      missed:0,
    }
  }
}
