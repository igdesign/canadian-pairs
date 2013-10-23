module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig

    shell:
      dev:
        command: 'rm -rf _build; rm -rf tmp; mkdir tmp;'

    jekyll:
      config: '_config.yml'

    sass:
      options:
        precision: 3
        sourcemap: true
        noCache: true
      build:
        files:
          'tmp/css/style.css': 'assets/css/style.scss'
          'tmp/css/style-old-ie.css': 'assets/css/style-old-ie.scss'

    autoprefixer:
      options:
        browsers: ['last 2 version', 'ie 8', '> 1%']
      build:
        expand: true
        flatten: true
        src: 'tmp/css/**/*.css'
        dest: 'tmp/css/'

    cssmin:
      build:
        options:
          report: 'gzip'
        files:
          'tmp/css/style.css': 'tmp/css/style.css'

    csslint:
      build:
        src: 'tmp/css/style.css'

    coffee:
      options:
        sourceMap: true
      build:
        expand: true
        flatten: true
        cwd: 'assets/js'
        src: '**/*.coffee'
        dest: 'tmp/js/'
        ext: '.js'

    uglify:
      options:
        report: 'gzip'
      build:
        expand: true
        flatten: true
        cwd: 'tmp/js/'
        src: '**/*.js'
        dest: '_build/assets/js/'

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
        src: ['_build/**/*.html']
        dest: ''

    imagemin:
      options:
        pngquant: true
      dist:
        expand: true
        cwd: 'assets/img/'
        src: '**/*.{png,jpg,gif}'
        dest: 'tmp/img/'

    copy:
      svg:
        expand: true
        cwd: 'assets/img/'
        src: '**/*.svg'
        dest: 'tmp/img/'
      images:
        expand: true
#         flatten: true
        cwd: 'assets/img/'
        src: ['**/*.png', '**/*.svg', '**/*.jpg', '**/*.gif']
        dest: 'tmp/img/'
      images_dev:
        expand: true
#         flatten: true
        cwd: 'tmp/img/'
        src: '**/*.*'
        dest: '_build/assets/img/'
      css:
        expand: true
        flatten: true
        cwd: 'tmp/css/'
        src: ['**/*.css', '**/*.map']
        dest: '_build/assets/css/'
      js:
        expand: true
#         flatten: true
        cwd: 'assets/js/'
        src: '**/*.js'
        dest: 'tmp/js/'
      js_dev:
        expand: true
#         flatten: true
        cwd: 'tmp/js/'
        src: ['**/*.js', '**/*.js.map']
        dest: '_build/assets/js/'

    connect:
      dev:
        options:
          port: 4000
          base: '_build'
          livereload: true

    watch:
      coffee:
        files: ['assets/js/**/*.coffee', 'assets/js/**/*.js']
        tasks: 'js:dev'
      sass:
        files: 'assets/css/**/*.scss'
        tasks: 'css:dev'
      html:
        files: ['**/*.html', '!_build/**/*.html']
        tasks: 'default'
      markdown:
        files: '**/*.md'
        tasks: 'default'
      images:
        files: ['assets/img/**/*.png', 'assets/img/**/*.jpg', 'assets/img/**/*.svg']
        tasks: 'media:dev'
      livereload:
        options:
          livereload: true
        files: ['_build/**/*']

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compress'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-csslint'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-jekyll'
  grunt.loadNpmTasks 'grunt-shell'

  # Default task.
  grunt.registerTask 'default', ['shell:dev', 'jekyll', 'css:dev', 'js:dev', 'media:dev', 'connect', 'watch']
  grunt.registerTask 'dist',    ['shell:dev', 'jekyll', 'css:dist', 'js:dist', 'htmlmin', 'media:dist', 'connect', 'watch']

  grunt.registerTask 'css:dev',    ['sass', 'autoprefixer', 'copy:css']
  grunt.registerTask 'css:dist',   ['sass', 'autoprefixer', 'cssmin', 'copy:css']
  grunt.registerTask 'js:dev',     ['coffee', 'copy:js', 'copy:js_dev']
  grunt.registerTask 'js:dist',    ['coffee', 'copy:js', 'uglify']
  grunt.registerTask 'media:dev',  ['copy:images', 'copy:images_dev']
  grunt.registerTask 'media:dist', ['imagemin:dist', 'copy:svg', 'copy:images_dev']