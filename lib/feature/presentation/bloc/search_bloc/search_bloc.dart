import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/feature/domain/usecases/seatch_person.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_state.dart';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPersons;

  PersonSearchBloc({required this.searchPersons}) : super(PersonEmpty());

  @override
  Stream<PersonSearchState> mapEventTostate(PersonSearchEvent event) async* {
    if (event is SearchPersons) {
      yield* _mapFetchPersonsToState(event.personQuery);
    }
  }

  Stream<PersonSearchState> _mapFetchPersonsToState(String personQuery) async* {
    final failuerOrPerson =
        await searchPersons(SearchPersonParams(quare: personQuery));

    yield failuerOrPerson.fold(
        (failuer) => PersonSearchError(message: _mapFailureToMessage(failuer)),
        (person) => PersonSearchLoaded(persons: person));
  }

  String _mapFailureToMessage(Failure failuer) {
    switch (failuer.runtimeType) {
      case ServerFailure:
        return "Server Failuer";
      case CacheFailure:
        return "Cache Failuer";
      default:
        return "Unexpected Error";
    }
  }
}
