module.exports = (grunt) -> 

  # Project configuration.
  grunt.initConfig

    requirejs: 
	    compile: 
	      options: 
	        mainConfigFile: 'src/main.js'
	        baseUrl: "src"
	        name: "main"
	        out: 'src/app.min.js'
	        useStrict: true #unknown
	        wrap: true #unknown
	        inlineText: true #unknown
	        stubModules: ['text'] #unknown
  
  # Load the plugin that provides the "uglify" task.
  #grunt.loadNpmTasks('grunt-contrib-uglify');

  grunt.loadNpmTasks('grunt-contrib-requirejs');

  # Default task(s).
  # grunt.registerTask('default', ['uglify']);
  grunt.registerTask('default', 'requirejs');