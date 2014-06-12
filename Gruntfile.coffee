module.exports = (grunt) -> 

  # Project configuration.
  grunt.initConfig

    requirejs: 
	    compile: 
	      options: 
	        baseUrl: "src"
	        mainConfigFile: 'src/main.js'
	        name: "main"
	        out: 'src/app.min.js'
	        useStrict: false
	        wrap: false
	        inlineText: true 
	        stubModules: ['text']
	        optimize: "uglify2"
	        optimizeAllPluginResources: true
	        findNestedDependencies: true,
	        paths:
	         'text': '../assets/lib/requirejs-text/text' # relative to baseUrl

  
  # Load the plugin that provides the "uglify" task.
  #grunt.loadNpmTasks('grunt-contrib-uglify');

  grunt.loadNpmTasks('grunt-contrib-requirejs');

  # Default task(s).
  # grunt.registerTask('default', ['uglify']);
  grunt.registerTask('default', 'requirejs');