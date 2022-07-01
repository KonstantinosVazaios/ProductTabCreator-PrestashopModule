document.addEventListener('DOMContentLoaded', function() {
    const addTabBtns = document.querySelectorAll('#addTabBtn');
    addTabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const idType = btn.dataset.type;
            const form = document.querySelector(`[data-type=${idType}]`)
            const tabRow = document.getElementById('tabRowForCopy')
            const tabRowNew = tabRow.cloneNode(true)
            tabRowNew.style.display = "block"
            form.appendChild(tabRowNew);
        })
    })
}, false);

