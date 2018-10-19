#Notas: David,9,2,5,1,1
#       Gonzalo,10,2, A,8,1
#       Mai,10,10,9,9, A
#       JP,10,10,10,10,10
#Donde la A señala que el alumno estuvo ausente en la prueba.

# 1- Información del problema

# Hay un archivo csv "alumnos" con 5 notas. Si no asistió a evaluación, se considera como inasistencia (las notas son asistencias).


test_options = ['Opción 01: Crear Archivo',
                'Opción 02: Mostrar Inasistencias',
                'Opción 03: Mostrar Alumnos Aprobados',
                'Opción 04: Salir del Programa']

option_selected = 0

test_welcome_message = 'Bienvenido al Software de Revisión de Notas y Asistencia :)'

new_welcome_message = 'Ingrese una opción de 1 a 3 si desea realizar más acciones dentro del programa, ingrese 4 para Salir :)'

option_exit = test_options.length

# 2- Declaración de procesamiento

def pick_alternative(options)
  alternative_selected = gets.chomp
  alternative_transformed = alternative_selected.to_f.to_i
  options_quantity = options.length

    while !(0 < alternative_transformed and alternative_transformed <= options_quantity)
      puts "Escribiste '#{alternative_selected}', y ésta es una opción no válida :(."
      puts "Debes escoger un número entre '1' y '#{options_quantity}'"
      alternative_selected = gets.chomp
      alternative_transformed = alternative_selected.to_i
    end
    return alternative_transformed
end

def welcome_message(message)
  puts message
end

def show_menu(menu_options)
  menu_text = menu_options.join("\n")
  puts menu_text
end

# Opción 1
def create_average_score_file(file_name)
  file = File.open(file_name, 'r')
  # Se asume que la inasistencia se cuenta como 0, sin punto base :(
  students = file.readlines.map{ |lines| lines.chomp }.map{ |lines| lines.tr('A','0')}.map{|lines| lines.strip.split(",")}
  file.close
  # print students
  file = File.open('PromedioNotas.txt', 'w')
  students.each do |element|
    student_name = element.first
    scores = element[1..element.length]
    sum = 0
    student_average_score = 0
    scores.each do |score|
      sum += score.to_i
      student_average_score = (sum/(element.length - 1).to_f)
      # Se quita 1 al método length para eliminar el elemento Nombre
    end
    file.write "la nota promedio del estudiante #{student_name} es de:"
    file.write " #{student_average_score} \n"
  end
  file.close
end

# Opción 2
def show_absence(file_name)
  file = File.open(file_name, 'r')
  students = file.readlines.map{ |lines| lines.chomp }.map{|lines| lines.strip.split(",")}
  file.close
  course_absences = 0
  students.each do |element|
    student_name = element.first
    absences = element.count('A')
    course_absences += element.count('A')
    puts "#{student_name} tiene #{absences} inasistencias."
  end
  puts "El total de inasistencias del curso es de #{course_absences}"
end

# Opción 3
def show_approved_students(file_name)
  file = File.open(file_name, 'r')
  students = file.readlines.map{ |lines| lines.chomp }.map{ |lines| lines.tr('A','0')}.map{|lines| lines.strip.split(",")}
  file.close
  puts 'Escriba una nota mínima para considerarla como criterio de aprobación.'
  puts 'Si su respuesta no es una nota o cero, la nota de aprobación por defecto será de 5.0'
  approval_score = gets.chomp.to_f
  
  if approval_score != 0.0
    puts "La nueva nota mínima para aprobar es de #{approval_score}"
  else
    approval_score = 5.0
    puts "La nota mínima para aprobar se mantendrá como #{approval_score}"
  end

  students_approved = 0

  students.each do |element|
    scores = element[1..element.length]
    sum = 0
    student_average_score = 0
    scores.each do |score|
      sum += score.to_i
      student_average_score = (sum/(element.length - 1).to_f)
      # Se quita 1 al método length para eliminar el elemento Nombre
    end
    if approval_score <= student_average_score
      then students_approved += 1
    end
  end
  puts "La cantidad de alumnos approbados del curso es: #{students_approved}"
end

# Opción 4
def close_session
    print "Elegiste Salir, kbye~"
    exit
end

# 3 - Procesar

welcome_message(test_welcome_message)
show_menu(test_options)

while (option_selected != option_exit) do
    option_selected = pick_alternative(test_options)
    case option_selected
    when 1
        create_average_score_file('alumnos.csv')
        welcome_message(new_welcome_message)
    when 2
        show_absence('alumnos.csv')
        welcome_message(new_welcome_message)
    when 3
        show_approved_students('alumnos.csv')
        welcome_message(new_welcome_message)
    when option_exit
        close_session
        break
    end
end
