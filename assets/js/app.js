

// any CSS you import will output into a single css file (app.css in this case)
import '../css/app.scss';

const enableDropdowns = () => {
    const dropdownElementList = document.querySelectorAll('.dropdown-toggle')
    const dropdownList = [...dropdownElementList].map(dropdownToggleEl => new bootstrap.Dropdown(dropdownToggleEl))

}

const carousel = new bootstrap.Carousel('#carouselExampleControlsNoTouching')
