import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_project/core/common/error_text.dart';
import 'package:reddit_project/core/common/loader.dart';
import 'package:reddit_project/core/models/community_model.dart';
import 'package:reddit_project/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref
        .watch(searchCommunityProvider(query))
        .when(
          data:
              (communites) => ListView.builder(
                itemCount: communites.length,
                itemBuilder: (BuildContext context, int index) {
                  final community = communites[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(community.avatar),
                    ),
                    title: Text('r/${community.name}'),
                    onTap: () => navigateToCommunity(context, community),
                  );
                },
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }
}
