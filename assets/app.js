import './css/app.scss';

require('./bootstrap');

// Chargement des éléments JS de Bootstrap
require('bootstrap/js/src/base-component');
require('bootstrap/js/src/popover');
require('bootstrap/js/src/collapse');

require('bootstrap/js/src/dropdown');
require('bootstrap/js/src/offcanvas');

// Intercepteur mailto/tel sur desktop : copie au lieu de declencher l'app systeme
import './js/contact-link-handler';



