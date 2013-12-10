###
0) Remove .tmp folder
1) Build 'assets/sass' to '.tmp/css'
2) Process '.tmp/css/*'
3) Build 'assets/coffeescript' to '.tmp/js'
4) Process '.tmp/js/*'
5) Process '_assets/img' to 'assets/img'
6) Jekyll Build
###

module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*!\n' +
             ' * <%= pkg.name %> v<%= pkg.version %> by <%= pkg.author %>\n' +
             ' * Copyright <%= grunt.template.today("yyyy") %> <%= pkg.copyright %>\n' +
             ' * Licensed under <%= pkg.license %>\n' +
             ' */'

    copy:
      css:
        expand: true
        cwd: '.tmp/css/'
        src: ['**/*.css', '**/*.map']
        dest: 'assets/css/'
      css_dev:
        expand: true
        cwd: 'assets/css/'
        src: ['**/*.css', '**/*.map']
        dest: '_site/assets/css/'

      js_tmp:
        expand: true
        cwd: '_assets/js/'
        src: '**/*.js'
        dest: '.tmp/js/'
      media:
        expand: true
        cwd: '_assets/img/'
        src: ['**/*.jpg', '**/*.png', '**/*.svg']
        dest: 'assets/img/'


    shell:
      build:
        command: 'rm -rf _site .tmp;'

    sass:
      options:
        precision: 5
        sourcemap: true
      build:
        files: [{
          expand: true,
          cwd:  '_assets/sass/',
          dest: '.tmp/css/',
          src:  ['*.scss', '!_*.scss']
          ext:  '.css'
        }]

    autoprefixer:
      options:
        browsers: ['last 2 version', 'ie 9', '> 1%']
      build:
        expand: true
        flatten: true
        cwd: '.tmp/css/'
        src: '**/*.css'
        dest: '.tmp/css/'

    cssmin:
      build:
        options:
          report: 'gzip'
          keepSpecialComments: 1
        files: [{
          expand: true
          cwd: '.tmp/css/'
          src: '**/*.css'
          dest: '.tmp/css/'
          ext: '.css'
        }]

    usebanner:
      css:
        options:
          position: 'top'
          banner: '<%= banner %>'
        files:
          src: '.tmp/css/**/*.css'
      js:
        options:
          position: 'top'
          banner: '<%= banner %>'
        files:
          src: 'assets/js/**/*.js'

    coffee:
      options:
        sourceMap: true
        bare: true
      build:
        expand: true
        cwd: '_assets/coffeescript'
        src: '**/*.coffee'
        dest: '.tmp/js/'
        ext: '.js'

    uglify:
      options:
        preserveComments: 'some'
#         report: 'gzip'
        compress:
          global_defs:
            "DEBUG": false
          dead_code: true
      build:
        expand: true
        cwd: '.tmp/js/'
        src: '**/*.js'
        dest: 'assets/js/'


    jekyll:
      build:
        options:
          config: '_config.yml'


    # !Connect
    connect:
      build:
        options:
          port: 4000
          base: '_site'
          livereload: true

    # !Watch
    watch:
      coffee:
        files: '_assets/js/**/*.coffee'
        tasks: 'js'
      js:
        files: '_assets/js/**/*.js'
        tasks: 'js'
      sass:
        files: '_assets/sass/**/*.scss'
        tasks: 'css'
      html:
        files: ['index.html', '_includes/**/*.html', '_layouts/**/*.html', 'privacy.md', 'terms-of-service.md', '_posts/**/*.md']
        tasks: 'default'
      livereload:
        options:
          livereload: true
        files: '_site/**/*'


  # !Load Tasks
  require("load-grunt-tasks") grunt

  grunt.registerTask 'default', [
    'shell'
    'css'
    'js'
    'copy:media'
    'jekyll'
#     'connect'
    'watch'
  ]


  grunt.registerTask 'css', [
    'sass'
    'autoprefixer'
#     'cssmin'
#     'usebanner:css'
    'copy:css'
    'copy:css_dev'
  ]

  grunt.registerTask 'js', [
    'coffee'
    'copy:js_tmp'
    'uglify'
  ]
