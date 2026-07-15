
  function loadContent(contentUrl) {
    // Fetch content based on contentUrl
    fetch(contentUrl)
      .then(response => response.text())
      .then(data => {
        const content = document.getElementById('mainContent');
        content.innerHTML = data;
      })
      .catch(error => console.error('Error fetching content:', error));
  }