
    function resetSeanceScheduleForm() {
    document.getElementById('SeanceScheduleForm').reset();
}

    function openAddSeanceModal() {
    // Show the modal for adding a seance
    document.getElementById('addSeanceModal').style.display = 'block';
}

    function closeAddSeanceModal() {
    // Close the modal for adding a seance
    document.getElementById('addSeanceModal').style.display = 'none';
}

    // Add this part to handle the form submission for adding a seance
    document.getElementById('SeanceScheduleForm').addEventListener('submit', function (event) {
    // Prevent the default form submission
    event.preventDefault();

    // Handle the form data as needed (e.g., send it to the server)

    // Close the modal after handling the form
    closeAddSeanceModal();
});

