package expo.modules.updates.selectionpolicy;

import org.json.JSONObject;

import expo.modules.updates.db.entity.UpdateEntity;

/**
 * Implementations of this class should be able to determine whether to load (either fetch remotely
 * or copy from an embedded location) a new update, given information about the one currently
 * running.
 */
public interface LoaderSelectionPolicy {
    boolean shouldLoadNewUpdate(UpdateEntity newUpdate, UpdateEntity launchedUpdate, JSONObject filters);
}
