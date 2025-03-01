// 予約を作成する関数
async function createReservation() {
  const reservationData = [
      { product_id: 10001001, quantity: 2 },
      { product_id: 10001002, quantity: 3 }
  ];

  const response = await fetch('http://localhost:8080/shop/v1/payments/reservations', {
      method: 'POST',
      headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
      },
      body: JSON.stringify(reservationData)
  });

  const data = await response.json();
  const reservationId = data.reservation_id;

  // 予約IDを表示する
  displayReservationId(reservationId);
}

// 予約IDを画面に表示する関数
function displayReservationId(reservationId) {
  const resultContainer = document.getElementById('reservation-result');
  resultContainer.innerHTML = `
      予約完了<br>
      予約ID: <strong>${reservationId}</strong>
  `;
}
