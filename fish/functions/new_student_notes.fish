function new_student_notes
    if test -e "$argv[1].notes"
        echo "$argv[1].notes already exists, opening existing file."
    else
        cp template.notes "$argv[1].notes"
    end
    nvim "$argv[1].notes"
end
