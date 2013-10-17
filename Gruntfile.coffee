module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig

    htmlmin:
      dist:
        options:
          removeComment: true
          collapseWhitespace: true
          removeAttributeQuotes: true
          removeRedundantAttributes: true
          useShortDoctype: true
          removeEmptyAttributes: true
          removeOptionalTags: true
        expand: true
        src: ['**/*.html', '!node_modules/**/*.html', '!_build/**/*.html']
        dest: '_build/'

    shell:
      dev:
        command: 'rm -rf _build; rm -rf tmp; mkdir tmp;'

    jekyll:
      config: '_config.yml'

    sass:
      options:
        precision: 3
      dev:
        files:
          'tmp/css/style.css': 'assets/css/style.scss'

    autoprefixer:
      options:
        browsers: ['last 2 version', 'ie 8', '> 1%']
      dev:
        src: 'tmp/css/style.css'
        dest: '_build/assets/css/style.css'

    coffee:
      dev:
        expand: true,
        cwd: 'assets/js'
        src: ['*.coffee']
        dest: '_build/assets/js/',
        ext: '.js'

    connect:
      dev:
        options:
          port: 4000
          base: '_build'
          livereload: true

    copy:
      images:
        src: 'assets/img/**/*'
        dest: '_build/assets/img/'

    watch:
      coffee:
        files: '**/*.coffee'
        tasks: ['coffee']
      sass:
        files: '**/*.scss'
        tasks: ['sass:dev', 'autoprefixer:dev']
      html:
        files: '**/*.html'
        tasks: ['jekyll-build']
      markdown:
        files: '**/*.md'
        tasks: ['jekyll-build']
      images:
        files: 'assets/img/**/*.*'
        tasks: ['copy:images']
      livereload:
        options:
          livereload: true
        files: ['_build/**/*']

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
# grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-jekyll'
  grunt.loadNpmTasks 'grunt-shell'

  # Default task.
  grunt.registerTask 'default', ['shell:dev', 'jekyll', 'sass:dev', 'autoprefixer:dev', 'coffee:dev', 'connect', 'watch']

  grunt.registerTask 'jekyll-build', ['shell:dev', 'jekyll', 'sass:dev', 'autoprefixer:dev', 'coffee:dev']