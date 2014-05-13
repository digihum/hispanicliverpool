Hispanic Liverpool
=================

A backbonejs app for the Hispanic Liverpool project with AMD


This is a first backbone.js application, and cherrypicks the features of backbone that work for the project. Also worth noting that its being developed as a standalone, but will ultimately be delployed onto a content management system as an in-page js app.

Uses
----
* text plugin for mixing templates with .html.tpl extension
* requirejs for AMD implementation 

Todo
----
* Move from dataTables to backgrid with paginatebackgrid http://backgridjs.com/ref/extensions/paginator.html https://github.com/backbone-paginator/backbone-pageable#playable-demos
* Link up the search form
* Consider whether modularising the main app.js will be beneficial. Currently its all in a single app.js because it was historically all on the single index.html
*Styling improvements requested to make this whole app more compact in appearance.

Influences
----------
In creating this app, I drew on a number of helpful resources:
* http://backbonetutorials.com/organizing-backbone-using-modules/
* http://jsdude.wordpress.com/2012/12/11/requirejs-and-backbone-template-preloading/
* http://gregfranko.com/blog/require-dot-js-2-dot-0-shim-configuration/ shim stuff
* http://weblog.bocoup.com/organizing-your-backbone-js-application-with-modules/ took the application structure from here, and may come back for modularisation
* http://vimeo.com/32765088 to give me the confidence to give it a go
