<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="_csrf" content="${_csrf.token}"/>
  <title>Finance Dashboard</title>
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .card-body {
      padding: 1rem;
    }
    .progress-bar {
      transition: width 0.5s ease;
    }

    /* Make the sidebar sticky */
    #sidebar {
      position: sticky;
      top: 0;
      height: 100vh;
      padding-top: 20px;
    }

    /* Highlight the active menu item */
    .nav-link.active {
      background-color: #f0f0f0;
      font-weight: bold;
    }
  </style>
</head>
<body>

  <!-- Navbar -->
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
      <a class="navbar-brand" href="#"><h3><span class="highlight" style="color:black;">NextGen </span><span style="color: #0056b3;">Finance</span></h3></a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item">
            <a class="nav-link" href="/"><h5>Logout</h5></a>
          </li>
        </ul>
      </div>
    </div>
  </nav>

  <!-- Main Container -->
  <div class="container-fluid">
    <div class="row">
      <!-- Sidebar -->
      <div class="col-md-2 bg-light p-4" id="sidebar">
        <ul class="nav flex-column" id="sidebar-nav">
          <li class="nav-item">
            <a class="nav-link active" href="#" id="goal-setter-link">Goal Setter</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#" id="budget-planner-link">Budget Planner</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#" id="expense-tracker-link">Expense Tracker</a>
          </li>
        </ul>
      </div>

      <!-- Main Content -->
    <div class="col-md-10 p-4">
        <!-- Goal Setter -->
        <div id="goal-setter" class="section">
          <!-- Button to trigger the modal -->
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h3>Goal Setter</h3>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addGoalModal">
              Add Goal
            </button>
          </div>

          <!-- Modal for adding a new goal -->
          <div class="modal fade" id="addGoalModal" tabindex="-1" aria-labelledby="addGoalModalLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="addGoalModalLabel">Add Goal Setter</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <form id="goalForm" action="/home/goalsetter" method="post">
                    <div class="mb-3">
                      <label for="goalName" class="form-label">Name of Goal</label>
                      <input type="text" class="form-control" id="goalName" name="goalname" required placeholder="Enter goal name">
                    </div>
                    <div class="mb-3">
                      <label for="targetAmount" class="form-label">Target Amount</label>
                      <input type="number" class="form-control" id="targetAmount" name="target" required placeholder="Enter target amount">
                    </div>
                    <button type="submit" class="btn btn-primary">Set</button>
                  </form>
                </div>
              </div>
            </div>
        </div>

          <!-- Goals Table -->
          <table class="table">
            <thead>
              <tr>
                <th scope="col">Goal Name</th>
                <th scope="col">Target Amount</th>
                <th scope="col">Remaining Amount</th>
                <th scope="col">Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="goal" items="${userGoals}">
                <tr>
                  <td>${goal.goalName}</td>
                  <td>${goal.target}</td>
                  <td>${goal.target - (goal.remainingAmount != null ? goal.remainingAmount : 0)}</td>
                  <td>
                    <button class="btn btn-success btn-sm" 
                            onclick="openPayModal('${goal.goalName}', ${goal.target - (goal.remainingAmount != null ? goal.remainingAmount : 0)}, ${goal.id})"
                            data-goalid="${goal.id}">
                      Pay
                    </button>
                    <button class="btn btn-danger btn-sm ms-2" 
	                      onclick="deleteGoal(${goal.id})">
	                      Delete
                    </button>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>

          <!-- Payment Modal -->
          <div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="paymentModalLabel">Make Payment</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <form id="paymentForm" action="/home/goalsetter/payment" method="post">
                    <input type="hidden" id="goalId" name="goalId">
                    <div class="mb-3">
                      <label class="form-label">Goal Name</label>
                      <input type="text" class="form-control" id="modalGoalName" readonly>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Remaining Amount</label>
                      <input type="text" class="form-control" id="modalRemainingAmount" readonly>
                    </div>
                    <div class="mb-3">
                      <label for="paymentAmount" class="form-label">Payment Amount</label>
                      <input type="number" class="form-control" id="paymentAmount" name="paymentAmount" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Submit Payment</button>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Budget Planner -->
        
        <div id="budget-planner" class="section" style="display: none;">
        
        
        <!-- budget planner ml-->
		        <div class="container mt-5 d-flex justify-content-center">
		        <div class="card col-6 p-4">
		            <h2 class="mb-4 text-center">Predict Your Financial Plan</h2>
		            <form id="predictForm">
		                <div class="row mb-3">
		                    <div class="col">
		                        <label for="income" class="form-label">Income</label>
		                        <input type="number" class="form-control" id="income" name="income" required>
		                    </div>
		                    <div class="col">
		                        <label for="age" class="form-label">Age</label>
		                        <input type="number" class="form-control" id="age" name="age" required>
		                    </div>
		                    <div class="col">
		                        <label for="dependents" class="form-label">Dependents</label>
		                        <input type="number" class="form-control" id="dependents" name="dependents" required>
		                    </div>
		                </div>
		                
		                <div class="row mb-3">
		                    <div class="col">
		                        <label for="occupation" class="form-label">Occupation</label>
		                        <select class="form-select" id="occupation" name="occupation" required>
		                            <option value="1">Self Employed</option>
		                            <option value="2">Professional</option>
		                            <option value="3">Retired</option>
		                            <option value="4">Student</option>
		                        </select>
		                    </div>
		                    <div class="col">
		                        <label for="city_tier" class="form-label">City Tier</label>
		                        <select class="form-select" id="city_tier" name="city_tier" required>
		                            <option value="1">Tier 1</option>
		                            <option value="2">Tier 2</option>
		                            <option value="3">Tier 3</option>
		                        </select>
		                    </div>
		                </div>
		                
		                <div class="row mb-3">
		                    <div class="col">
		                        <label for="loan_repayment" class="form-label">Loan Repayment</label>
		                        <input type="number" class="form-control" id="loan_repayment" name="loan_repayment" required>
		                    </div>
		                    <div class="col">
		                        <label for="insurance" class="form-label">Insurance</label>
		                        <input type="number" class="form-control" id="insurance" name="insurance" required>
		                    </div>
		                </div>
		                
		                <div class="text-center">
		                    <button type="submit" class="btn btn-primary">Predict Plan</button>
		                </div>
		            </form>
		        </div>
		    </div>
		    
		    
		    <!-- predicted values -->
		    <!-- Modal Structure -->
		    
		    <div id="responseModal" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%, -50%); width:50%; padding:20px; background-color:white; box-shadow:0 4px 8px rgba(0,0,0,0.2); z-index:1000;">
		        <h2>Prediction Result</h2>
		        <pre id="modalContent" style="background:#f4f4f4; padding:10px; border:1px solid #ddd; overflow:auto;"></pre>
		        <button onclick="closeModal()" style="margin-top:10px; padding:10px 20px; background-color:red; color:white; border:none; cursor:pointer;">Close</button>
		    </div>

		    <!-- Overlay for Modal -->
		    <div id="modalOverlay" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,0.5); z-index:999;" onclick="closeModal()"></div>

		   
		    
            <!-- budget name-->
	    	<div class="d-flex justify-content-between align-items-center pt-5 mb-3">
	        	<h3>Budget Planner</h3>
	        	<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBudgetModal">
        		Add Budget Name
        		</button>
	        </div>
	        
	        <!-- Modal for adding a new Budget -->
	          <div class="modal fade" id="addBudgetModal" tabindex="-1" aria-labelledby="addBudgetModalLabel" aria-hidden="true">
	            <div class="modal-dialog">
	              <div class="modal-content">
	                <div class="modal-header">
	                  <h5 class="modal-title" id="addBudgetModalLabel">Add Goal Setter</h5>
	                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	                </div>
	                <div class="modal-body">
	                  <form id="budgetForm" action="/home/budgetplanner" method="post">
	                    <div class="mb-3">
	                      <label for="budgetName" class="form-label">Name for Budget</label>
	                      <input type="text" class="form-control" id="budgetName" name="budgetName" required placeholder="Enter goal name">
	                    </div>
	                    <div class="mb-3">
	                      <label for="budgetAmount" class="form-label">Target Amount</label>
	                      <input type="number" class="form-control" id="budgetAmount" name="budgetAmount" required placeholder="Enter target amount">
	                    </div>
	                    <button type="submit" class="btn btn-primary">Set</button>
	                  </form>
	                </div>
	              </div>
	            </div>
	          </div>
	          
	          <!-- Budget Planner Table -->
	          <table class="table">
	            <thead>
	              <tr>
	                <th scope="col">Budget Name</th>
	                <th scope="col">Amount</th>
	                <th scope="col">Action</th>
	              </tr>
	            </thead>
	            <tbody>
	              <c:forEach var="budget" items="${userBudgets}">
	                <tr>
	                  <td>${budget.budget_name}</td>
	                  <td>${budget.budget_amount}</td>
	                  <td>
	                      <button class="btn btn-success btn-sm" 
	                      onclick="openBudgetPayModal(${budget.budget_amount}, ${budget.id})"
	                              data-budgetId="${budget.id}">
	                          Pay
	                      </button>
	                      <button class="btn btn-danger btn-sm ms-2" 
		                      onclick="deleteBudget(${budget.id})">
		                      Delete
		                  </button>
	                  </td>
	                </tr>
	              </c:forEach>
	            </tbody>
	          </table>
	          
	          
	          <!-- Budget Payment Modal -->
	          <div class="modal fade" id="paymentBudgetModal" tabindex="-1" aria-labelledby="paymentBudgetModalLabel" aria-hidden="true">
	            <div class="modal-dialog">
	              <div class="modal-content">
	                <div class="modal-header">
	                  <h5 class="modal-title" id="paymentBudgetModalLabel">Make Budget Payment</h5>
	                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	                </div>
	                <div class="modal-body">
	                  <!-- Updated form ID to match JavaScript -->
	                  <form id="paymentBudgetForm" action="/home/budgetplanner/payment" method="post">
	                    <input type="hidden" id="budgetId" name="budgetId">	                    
	                    <div class="mb-3">
	                      <label for="budgetAmount" class="form-label">Payment Amount</label>
	                      <div class="input-group">
	                        <span class="input-group-text">$</span>
	                        <input type="number" 
	                               class="form-control" 
	                               id="budgetAmount" 
	                               name="budgetAmount" 
	                               step="0.01" 
	                               min="0.01" 
	                               required 
	                               placeholder="Enter amount">
	                      </div>
	                    </div>
	                    <div class="d-grid gap-2">
	                      <button type="submit" class="btn btn-primary">Submit Payment</button>
	                      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
	                    </div>
	                  </form>
	                </div>
	              </div>
	            </div>
	          </div>
	    </div>
        
       

        <!-- Expense Tracker -->
        <div id="expense-tracker" class="section" style="display: none;">
	    	<div class="d-flex justify-content-between align-items-center mb-3">
	        	<h3>Expense Tracker</h3>
	        	<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addExpenseModal">
	    		Add Expense Name
	    		</button>
	        </div>
        
	        <!-- Modal for adding a new Budget -->
	          <div class="modal fade" id="addExpenseModal" tabindex="-1" aria-labelledby="addExpenseModalLabel" aria-hidden="true">
	            <div class="modal-dialog">
	              <div class="modal-content">
	                <div class="modal-header">
	                  <h5 class="modal-title" id="addExpenseModalLabel">Add Expense Name</h5>
	                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	                </div>
	                <div class="modal-body">
	                  <form id="budgetForm" action="/home/expensetracker" method="post">
	                    <div class="mb-3">
	                      <label for="expenseName" class="form-label">Expense Name</label>
	                      <input type="text" class="form-control" id="expenseName" name="expenseName" required placeholder="Enter goal name">
	                    </div>
	                    <div class="mb-3">
	                      <label for="expenseAmount" class="form-label">Enter Amount</label>
	                      <input type="number" class="form-control" id="expenseAmount" name="expenseAmount" required placeholder="Enter target amount">
	                    </div>
	                    <button type="submit" class="btn btn-primary">Add</button>
	                  </form>
	                </div>
	              </div>
	            </div>
	          </div>
	        
	          <table class="table">
	            <thead>
	              <tr>
	              	<th scope="col">Expense Name</th>
	                <th scope="col">Expense Amount</th>
	                <th scope="col">Action</th>
	              </tr>
	            </thead>
	            <tbody>
	              <c:forEach var="expense" items="${userExpenses}">
	                <tr>
	                  <td>${expense.expenseName}</td>
	                  <td>${expense.expenseAmount}</td>
	                  <td>
		                  <button class="btn btn-success btn-sm" 
		                      onclick="openExpensePayModal(${expense.expenseAmount}, ${expense.id})">
		                      Edit
		                  </button>
		                  <button class="btn btn-danger btn-sm ms-2" 
		                      onclick="deleteExpense(${expense.id})">
		                      Delete
		                  </button>
	                  </td>
	                </tr>
	              </c:forEach>
	            </tbody>
	          </table>
	          
	          <!-- Expense Payment Modal -->
	          <div class="modal fade" id="paymentExpenseModal" tabindex="-1" aria-labelledby="paymentExpenseModalLabel" aria-hidden="true">
	            <div class="modal-dialog">
	              <div class="modal-content">
	                <div class="modal-header">
	                  <h5 class="modal-title" id="paymentExpenseModalLabel">Make Budget Payment</h5>
	                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	                </div>
	                <div class="modal-body">
	                  <!-- Updated form ID to match JavaScript -->
	                  <form id="paymentExpenseForm" action="/home/expensetracker/payment" method="post">
	                    <input type="hidden" id="expenseId" name="expenseId">	                    
	                    <div class="mb-3">
	                      <label for="expenseAmount" class="form-label">Payment Amount</label>
	                      <div class="input-group">
	                        <span class="input-group-text">$</span>
	                        <input type="number" 
	                               class="form-control" 
	                               id="expenseAmount" 
	                               name="expenseAmount" 
	                               step="0.01" 
	                               min="0.01" 
	                               required 
	                               placeholder="Enter amount">
	                      </div>
	                    </div>
	                    <div class="d-grid gap-2">
	                      <button type="submit" class="btn btn-primary">Submit Payment</button>
	                      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
	                    </div>
	                  </form>
	                </div>
	              </div>
	            </div>
	          </div>
	    </div>
	</div>

  <!-- Bootstrap JS and dependencies -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

  <!-- JavaScript for Section Switching and Modal Handling -->
  <script>
    // Section switching
    document.getElementById("goal-setter-link").addEventListener("click", function() {
      showSection("goal-setter");
      setActiveLink("goal-setter-link");
    });
    document.getElementById("budget-planner-link").addEventListener("click", function() {
      showSection("budget-planner");
      setActiveLink("budget-planner-link");
    });
    document.getElementById("expense-tracker-link").addEventListener("click", function() {
      showSection("expense-tracker");
      setActiveLink("expense-tracker-link");
    });
    
    function showSection(sectionId) {
      const sections = document.querySelectorAll('.section');
      sections.forEach(function(section) {
        section.style.display = "none";
      });
      document.getElementById(sectionId).style.display = "block";
    }

    function setActiveLink(linkId) {
      const links = document.querySelectorAll('.nav-link');
      links.forEach(function(link) {
        link.classList.remove('active');
      });
      document.getElementById(linkId).classList.add('active');
    }

    // Payment modal handling
    function openPayModal(goalName, remainingAmount, goalId) {
      const modal = new bootstrap.Modal(document.getElementById('paymentModal'));
      document.getElementById('modalGoalName').value = goalName;
      document.getElementById('modalRemainingAmount').value = remainingAmount;
      document.getElementById('goalId').value = goalId;
      modal.show();
    }

    // Handle payment form submission
    document.getElementById('paymentForm').addEventListener('submit', function(e) {
      e.preventDefault();
      
      const formData = new FormData(this);
      
      fetch('/home/goalsetter/payment', {
        method: 'POST',
        body: formData
      })
      .then(response => response.json())
      .then(data => {
        if(data.success) {
          // Close modal
        	alert('successfully Updated!');
          bootstrap.Modal.getInstance(document.getElementById('paymentModal')).hide();
          // Reload page to show updated amounts
          window.location.reload();
        } else {
          alert('Error processing payment. Please try again.');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('Error processing payment. Please try again.');
      });
    });
    
    //delete the goal 
    function deleteGoal(goalId) {
        if (confirm('Delete this Goal ?')) {
            fetch('/home/goalsetter/delete/' +goalId , {
                method: 'DELETE',
            })
            .then(response => {
                if (response.ok) {
                	alert("Deleted Sucessfully !");
                    window.location.reload();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error deleting expense');
            });
        }
    }
    
    
    // budget predict 
    document.getElementById('predictForm').addEventListener('submit', function(event) {
        event.preventDefault(); // Prevent default form submission
        
        const formData = new URLSearchParams(new FormData(this)).toString(); 
        
        fetch('/home/budgetplanner/predict', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Round the numerical values to the nearest integer
                const roundedData = roundValues(data.data);

                // Format JSON response for better readability
                const formattedData = JSON.stringify(roundedData, null, 4);

                // Display the modal with the rounded response
                document.getElementById('modalContent').textContent = formattedData;
                document.getElementById('responseModal').style.display = 'block';
                document.getElementById('modalOverlay').style.display = 'block';
            } else {
                alert('Error: ' + (data.error || 'Unknown error occurred'));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error processing request');
        });
    });

		    // Function to round numerical values in the response
		    function roundValues(data) {
		        for (let key in data) {
		            if (typeof data[key] === 'number') {
		                data[key] = Math.round(data[key]); // Round the number to the nearest integer
		            }
		        }
		        return data;
		    }
		
		    // Close Modal Function
		    function closeModal() {
		        document.getElementById('responseModal').style.display = 'none';
		        document.getElementById('modalOverlay').style.display = 'none';
		    }



    
    document.querySelector('form').addEventListener('submit', submitForm);
    
    
    // Budget Payment modal handling
    function openBudgetPayModal(budget_amount, budgetId) {
      const modal = new bootstrap.Modal(document.getElementById('paymentBudgetModal'));
      document.getElementById('budgetAmount').value = budget_amount;
      document.getElementById('budgetId').value = budgetId;
      modal.show();
    }

    // Handle budget payment form submission
    document.getElementById('paymentBudgetForm').addEventListener('submit', function(e) {
      e.preventDefault();
      
      const formData = new FormData(this);
      
      fetch('/home/budgetplanner/payment', {
        method: 'POST',
        body: formData
      })
      .then(response => response.json())
      .then(data => {
        if(data.success) {
        	alert('successfully Updated!');
          // Close modal
          bootstrap.Modal.getInstance(document.getElementById('paymentBudgetModal')).hide();
          // Reload page to show updated amounts
          window.location.reload();
        } else {
          alert('Error processing budget payment. Please try again.');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('Error processing budget payment. Please try again.');
      });
    });
    
    
    //delete the budget
    
    function deleteBudget(budgetId) {
        if (confirm('Delete this Goal ?')) {
            fetch('/home/budgetplanner/delete/' +budgetId , {
                method: 'DELETE',
            })
            .then(response => {
                if (response.ok) {
                	alert("Deleted Sucessfully !");
                    window.location.reload();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error deleting expense');
            });
        }
    }
    
    // Expense Payment modal handling
    function openExpensePayModal(expenseAmount, expenseId) {
      const modal = new bootstrap.Modal(document.getElementById('paymentExpenseModal'));
      document.getElementById('expenseAmount').value = expenseAmount;
      document.getElementById('expenseId').value = expenseId;
      modal.show();
    }

    // Handle budget payment form submission
    document.getElementById('paymentExpenseForm').addEventListener('submit', function(e) {
      e.preventDefault();
      
      const formData = new FormData(this);
      
      fetch('/home/expensetracker/payment', {
        method: 'POST',
        body: formData
      })
      .then(response => response.json())
      .then(data => {
        if(data.success) {
        	alert('successfully Updated!');
          // Close modal
          bootstrap.Modal.getInstance(document.getElementById('paymentExpenseModal')).hide();
          // Reload page to show updated amounts
          window.location.reload();
        } else {
          alert('Error processing Expense payment. Please try again.');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('Error processing Expense payment. Please try again.');
      });
    });
    // delete the expense
    function deleteExpense(expenseId) {
        if (confirm('Delete this expense?')) {
            fetch('/home/expensetracker/delete/' + expenseId, {
                method: 'DELETE',
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error deleting expense');
            });
        }
    }
  </script>
</body>
</html>