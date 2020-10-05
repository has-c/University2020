from textbook.backtracking_search_solver import *
from textbook.min_conflicts_solver import *

#####################
# Your imports here #
#####################


def backtracking_search_instrumented(
        csp,
        select_unassigned_variable=first_unassigned_variable,
        order_domain_values=unordered_domain_values,
        inference=no_inference,
        max_steps=100_000,
):
    """Return a dict where the key 'assignment' is identical to to result of backtracking_search(csp, select_unassigned_variable, ...).

    The key 'num_assignments' == the number of times csp.assign is called.
    The key 'num_backtracks' == the number of backtracks performed.
    """
    class MaxSteps(Exception):
        """Raise to terminate backtracking."""
        def __init__(self, number_of_assignments, number_of_backtracks):
            self.number_of_assignments = number_of_assignments
            self.number_of_backtracks = number_of_backtracks

    def backtrack(assignment, number_of_assignments,number_of_backtracks):
        #if assignment is complete then return 
        if len(assignment) == len(csp.variables):
            return assignment, number_of_assignments, number_of_backtracks
        #select unassigned variables
        var = select_unassigned_variable(assignment, csp)
        
        for value in order_domain_values(var, assignment, csp):
            #hit max steps raise exception
            if csp.nassigns == max_steps:
                raise MaxSteps(number_of_assignments, number_of_backtracks)
            #if value is consistent with constraints
            if 0 == csp.nconflicts(var, value, assignment):
                #add to assignment 
                csp.assign(var, value, assignment)
                number_of_assignments += 1 #increment number of assignments
                removals = csp.suppose(var, value)
                if inference(csp, var, value, assignment, removals):
                    result,number_of_assignments, number_of_backtracks = backtrack(assignment,number_of_assignments,number_of_backtracks)
                    if result is not None:
                        return result, number_of_assignments, number_of_backtracks
                csp.restore(removals)
        #remove value from assignment thus backtrack
        csp.unassign(var, assignment)
        number_of_backtracks += 1

        return None, number_of_assignments, number_of_backtracks

    number_of_assignments = 0
    number_of_backtracks = 0
    try:
        result, number_of_assignments, number_of_backtracks = backtrack({}, number_of_assignments,number_of_backtracks)
    except MaxSteps as steps:
        result = None
        number_of_assignments = steps.number_of_assignments
        number_of_backtracks = steps.number_of_backtracks
    assert result is None or csp.goal_test(result)

    return {
        "assignment": result,
        "num_assignments": number_of_assignments,
        "num_backtracks": number_of_backtracks
    }


def min_conflicts_instrumented(csp, max_steps=100_000):
    """Return a dict where the key 'assignment' is identical to to result of min_conflicts(csp, max_steps).

    The key 'num_assignments' == the number of times csp.assign is called.
    The key 'num_repair_assignments' == the number of assignments made outside of generating the initial assignment of variables.
    """

    number_of_initial_assignments = 0
    num_repair_assignments = 0
    number_of_total_assignments = 0

    # Generate a complete assignment for all variables (probably with conflicts)
    csp.current = current = {}
    for var in csp.variables:
        val = min_conflicts_value(csp, var, current)
        csp.assign(var, val, current)
    
    number_of_initial_assignments = csp.nassigns

    # Now repeatedly choose a random conflicted variable and change it
    for _ in range(max_steps):
        conflicted = csp.conflicted_vars(current)
        if not conflicted:

            num_repair_assignments = csp.nassigns - number_of_initial_assignments
            number_of_total_assignments = csp.nassigns

            return {
                "assignment": current,
                "num_assignments": number_of_total_assignments,
                "num_repair_assignments": num_repair_assignments,
            }
        var = random.choice(conflicted)
        val = min_conflicts_value(csp, var, current)
        csp.assign(var, val, current)

    

    num_repair_assignments = csp.nassigns - number_of_initial_assignments
    number_of_total_assignments = csp.nassigns
    
    return {
        "assignment": None,
        "num_assignments": number_of_total_assignments,
        "num_repair_assignments": num_repair_assignments,
    }
